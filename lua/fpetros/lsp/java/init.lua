local has_haunt, haunt = pcall(require, 'haunt')

local google_java_format = require('fpetros.lsp.java.google-java-format')
local mvn = require('fpetros.lsp.java.mvn')
local manager = require('fpetros.lsp.java.manager')
local formatting = require('fpetros.lsp.formatting')
local mason_utils = require('fpetros.utils.mason')
local env = require('fpetros.config.env')

local M = {}

M.can_setup = function()
    return env.lsp.jdtls and
        env.lsp.jdtls.enabled and
        env.lsp.jdtls.settings and
        env.lsp.jdtls.settings.java and
        env.lsp.jdtls.settings.java.configuration and
        env.lsp.jdtls.settings.java.configuration.runtimes and
        mason_utils and
        formatting
end

M.setup = function(capabilities)
    if not M.can_setup() then
        return function() end
    end

    mason_utils.ensure_installed({
        'google-java-format',
        'lombok'
    })

    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = true }

        vim.keymap.set("n", "<leader>ff", google_java_format, opts)
        vim.keymap.set("v", "<leader>ff", google_java_format, opts)
        vim.keymap.set({ "n", "v" }, "<leader>jvm", manager.choose_java_version, opts)
        vim.keymap.set({ "n", "v" }, "<leader>jjvm", function()
            local default_java = manager.get_default_java_version(client.root_dir)
            if default_java then
                vim.notify('Java Runtime: ' .. default_java.name)
                return
            end
            vim.notify('Could not fetch java version', vim.log.levels.ERROR)
        end, opts)

        if vim.treesitter then
            vim.keymap.set({ 'n', 'v' }, '<leader>gsv', function()
                local dependency_classpath = mvn.get_dependency_classpath(client.root_dir,
                    manager.get_default_java_version(client.root_dir).path)
                if dependency_classpath then
                    local current_node = vim.treesitter.get_node({ bufnr = bufnr })

                    if not current_node then return "" end

                    local expr = current_node

                    while expr do
                        if expr:type() == 'program' then
                            break
                        end
                        expr = expr:parent()
                    end

                    if not expr then return "" end

                    local shell = vim.o.shell
                    local package_name = (vim.treesitter.get_node_text(expr:child(0):child(1), bufnr))
                    local file_parts = vim.split(vim.fn.expand('%:r'), '/')
                    local default_runtime = manager.get_default_java_version(client.root_dir)
                    local local_classpath = client.root_dir .. '/target/classes'

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
            end, opts)

            if has_haunt then
                vim.keymap.set({ 'n', 'v' }, '<leader>ttc', function()
                    local file_parts = vim.split(vim.fn.expand('%:r'), '/')

                    local test_descriptor = file_parts[#file_parts]
                    local java_home = manager.get_default_java_version(client.root_dir)

                    mvn.test(test_descriptor, client.root_dir, java_home.path)
                end, opts)

                vim.keymap.set({ 'n', 'v' }, '<leader>ttf', function()
                    local current_node = vim.treesitter.get_node({ bufnr = bufnr })

                    if not current_node then return "" end

                    local expr = current_node

                    while expr do
                        if expr:type() == 'method_declaration' then
                            break
                        end
                        expr = expr:parent()
                    end

                    if not expr then return "" end

                    local function_name = (vim.treesitter.get_node_text(expr:field('name')[1], bufnr))
                    local file_parts = vim.split(vim.fn.expand('%:r'), '/')
                    local test_descriptor = file_parts[#file_parts] .. '#' .. function_name
                    local java_home = manager.get_default_java_version(client.root_dir)

                    mvn.test(test_descriptor, client.root_dir, java_home.path)
                end, opts)
            end
        end

        formatting.set_server({ 'jdtls' }, google_java_format)

        local initial_config = vim.deepcopy(env.lsp.jdtls.settings)

        initial_config = manager.set_default_java_version_from_file(initial_config, client)
        manager.update_client_configuration(initial_config, client, true)
        mvn.get_dependency_classpath(client.root_dir, manager.get_default_java_version(client.root_dir).path)
    end

    local java_cmd = vim.lsp.config.jdtls.cmd
    local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/lombok/lombok.jar"

    table.insert(java_cmd,
        '--jvm-arg=-javaagent:' .. lombok_path)

    vim.lsp.config('jdtls', {
        cmd = java_cmd,
        capabilities = capabilities,
        settings = { settings = env.lsp.jdtls.settings },
    })

    return on_attach
end

return M
