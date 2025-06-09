local has_jdtls, jdtls = pcall(require, 'jdtls')
local has_dap, _ = pcall(require, 'dap')

local google_java_format = require('fpetros.lsp.java.google-java-format')
local ts = require('fpetros.utils.ts')
local manager = require('fpetros.lsp.java.manager')
local formatting = require('fpetros.lsp.formatting')
local mason_utils = require('fpetros.utils.mason')
local env = require('fpetros.config.env')

local M = {}
local _M = {}

M.can_setup = function()
    return env.lsp.jdtls and
        env.lsp.jdtls.enabled and
        env.lsp.jdtls.settings and
        env.lsp.jdtls.settings.java and
        env.lsp.jdtls.settings.java.configuration and
        env.lsp.jdtls.settings.java.configuration.runtimes and
        mason_utils and
        formatting and
        has_jdtls
end

M.setup = function(_)
    if not M.can_setup() then
        return function() end
    end

    mason_utils.ensure_installed({
        'google-java-format',
        'lombok',
        'java-test',
        'java-debug-adapter'
    })

    local root_dir = manager.get_root_dir()

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(_)
            local initial_config = vim.deepcopy(env.lsp.jdtls.settings)
            manager.init_runtimes(initial_config, root_dir)
            initial_config = manager.set_default_java_version_from_file(initial_config, root_dir)
            manager.get_dependency_classpath(root_dir)

            local cmd = manager.build_jdtls_cmd(root_dir)
            local bundles = {}

            vim.list_extend(bundles, manager.get_java_debug_bundle())
            vim.list_extend(bundles, manager.get_java_test_bundle())

            jdtls.start_or_attach({
                cmd = cmd,
                root_dir = root_dir,
                settings = initial_config,
                init_options = {
                    bundles = bundles
                }
            })
        end,
    })

    return function(event)
        formatting.set_server({ 'jdtls' }, google_java_format)
        _M.setup_keybinds(event, root_dir)
    end
end

_M.setup_keybinds = function(attach_event, root_dir)
    local opts = { buffer = attach_event.buf, remap = true }

    vim.keymap.set({ "n", "v" }, "<leader>ff", google_java_format, opts)

    if has_dap then
        vim.keymap.set({ "n", "v" }, "<leader>ttc", jdtls.test_class,
            vim.tbl_extend('force', opts, { desc = 'Test - Class' }))
        vim.keymap.set({ "n", "v" }, "<leader>ttf", jdtls.test_nearest_method,
            vim.tbl_extend('force', opts, { desc = 'Test - Method' }))
    end

    vim.keymap.set({ "n", "v" }, "<leader>jvm", function() manager.choose_java_version(root_dir) end,
        vim.tbl_extend('force', opts, { desc = 'Java - Choose Version' }))
    vim.keymap.set({ "n", "v" }, "<leader>jjvm", function()
        local default_java = manager.get_default_java_version(root_dir)
        if default_java then
            vim.notify('Java Runtime: ' .. default_java.name)
            return
        end
        vim.notify('Could not fetch java version', vim.log.levels.ERROR)
    end, vim.tbl_extend('force', opts, { desc = 'Java - Get Current Version' }))

    _M.setup_serial_version_generation(attach_event, root_dir, opts)
end

_M.setup_serial_version_generation = function(attach_event, root_dir, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>gsv', function()
        local dependency_classpath = manager.get_dependency_classpath(root_dir)

        if dependency_classpath then
            local program_node = ts.get_nearest_node({ 'program' }, { bufnr = attach_event.buf })

            if not program_node then
                vim.notify('Could not obtain package name', vim.log.levels.ERROR)
                return
            end

            local shell = vim.o.shell
            local package_name = ts.get_node_text(program_node:child(0):child(1), { bufnr = attach_event.buf })
            local file_parts = vim.split(vim.fn.expand('%:r'), '/')
            local default_runtime = manager.get_default_java_version(root_dir)
            local local_classpath = root_dir .. '/target/classes'

            local cmd = {
                shell,
                '-c',
                default_runtime.path ..
                '/bin/serialver -classpath "' ..
                local_classpath .. ':' .. dependency_classpath .. '" ' .. package_name .. '.' .. file_parts
                [#file_parts]
            }

            local result = vim.system(cmd, { text = true }):wait()

            if result.code == 0 then
                local text = '@Serial ' .. vim.trim(vim.split(
                    vim.split(result.stdout, '\n', { plain = true, trimempty = true })[1], ':')[2])

                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_option_value('filetype', 'java', { buf = buf })

                vim.api.nvim_buf_set_lines(buf, 0, -1, true, { text })

                vim.api.nvim_open_win(buf, true, {
                    height = 2,
                    win = 0,
                    split = 'above'
                })

                return
            end

            vim.notify(result.stderr, vim.log.levels.ERROR)
            return
        end

        vim.notify('Classpath still being processed...', vim.log.levels.WARN)
    end, vim.tbl_extend('force', opts, { desc = 'Generate serialVersionUID' }))
end

return M
