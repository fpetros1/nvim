local has_fzf, fzf = pcall(require, 'fzf-lua')
local has_haunt, haunt = pcall(require, 'haunt')

local formatting = require('fpetros.lsp.formatting')
local mason_utils = require('fpetros.utils.mason')
local env = require('fpetros.config.env')

local java_version_file = '.java.version'

local published_configuration = {}

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

    local format_code_using_google = function(event)
        local bufnr = 0

        if event ~= nil and event.buf ~= nil then
            bufnr = event.buf
        end

        local cmd         = {
            vim.fn.stdpath("data") .. "/mason/packages/google-java-format/google-java-format",
            "-"
        }

        local done_format = function(obj)
            vim.schedule(function()
                if obj.code == 0 then
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
                        vim.split(obj.stdout, '\n', { plain = true, trimempty = true }))
                    vim.cmd('noautocmd write')
                    return
                end
                vim.notify(obj.stderr, vim.log.levels.ERROR)
            end)
        end

        local obj         = vim.system(cmd,
                { text = true, stdin = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) })
            :wait()

        done_format(obj)
    end

    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = true }

        vim.keymap.set("n", "<leader>ff", format_code_using_google, opts)
        vim.keymap.set("v", "<leader>ff", format_code_using_google, opts)
        vim.keymap.set({ "n", "v" }, "<leader>jvm", M.choose_java_version, opts)
        vim.keymap.set({ "n", "v" }, "<leader>jjvm", function()
            local default_java = M.get_default_java_version()
            vim.notify('Java Runtime: ' .. default_java)
        end, opts)

        if vim.treesitter and has_haunt then
            vim.keymap.set({ 'n', 'v' }, '<leader>ttc', function()
                local file_parts = vim.split(vim.fn.expand('%:r'), '/')

                local runtimes = published_configuration[client.root_dir].java.configuration.runtimes
                local default_runtime = vim.tbl_filter(function(value) return value.default == true end, runtimes)[1]

                local test_descriptor = file_parts[#file_parts]

                local test_cmd = 'JAVA_HOME="' .. default_runtime.path .. '" mvn test -Dtest=' .. test_descriptor

                haunt.term({
                    fargs = {
                        vim.o.shell,
                        '-c',
                        test_cmd .. '; echo "Press any button to continue..." && read dummy'
                    }
                })
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

                local runtimes = published_configuration[client.root_dir].java.configuration.runtimes

                local default_runtime = vim.tbl_filter(function(value) return value.default == true end, runtimes)[1]

                local test_cmd = 'JAVA_HOME="' .. default_runtime.path .. '" mvn test -Dtest=' .. test_descriptor

                haunt.term({
                    fargs = {
                        vim.o.shell,
                        '-c',
                        test_cmd .. '; echo "Press any button to continue..." && read dummy'
                    }
                })
            end, opts)
        end

        formatting.set_server({ 'jdtls' }, format_code_using_google)

        local initial_config = vim.deepcopy(env.lsp.jdtls.settings)

        initial_config = M.set_default_java_version_from_file(initial_config, client)
        M.update_client_configuration(initial_config, client, true)
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

M.choose_java_version = function()
    if has_fzf then
        fzf.fzf_exec(function(fzf_cb)
            for _, item in ipairs(M.get_java_versions()) do
                fzf_cb(item)
            end
            fzf_cb()
        end, {
            winopts = {
                height = 0.30,
                width = 0.30,
            },
            actions = {
                ['default'] = function(selected)
                    local buf_client = vim.lsp.get_clients({ name = 'jdtls', bufnr = 0 })[1]

                    if buf_client then
                        local update_file = true
                        for _, client in ipairs(vim.lsp.get_clients({ name = 'jdtls' })) do
                            if buf_client.root_dir == client.root_dir then
                                local current_config = vim.deepcopy(published_configuration[client.root_dir])
                                current_config = M.update_default_java(current_config, selected[1])
                                M.update_client_configuration(current_config, client, update_file)
                                update_file = false
                            end
                        end
                    end
                end
            }
        })
    end
end

M.update_default_java = function(java_config, default_java_version)
    for _, runtime in ipairs(java_config.java.configuration.runtimes) do
        runtime.default = runtime.name == default_java_version and true or false
    end

    local has_default = false

    for _, runtime in ipairs(java_config.java.configuration.runtimes) do
        if runtime.default then
            has_default = true
            break
        end
    end

    if not has_default and #java_config.java.configuration.runtimes > 0 then
        java_config.java.configuration.runtimes[1].default = true
    end

    return java_config
end

M.update_client_configuration = function(java_config, client, update_file)
    if not vim.deep_equal(java_config, published_configuration[client.root_dir]) then
        local notificationResult = client:notify('workspace/didChangeConfiguration', {
            settings = java_config
        })

        if notificationResult then
            published_configuration[client.root_dir] = vim.deepcopy(java_config)

            if update_file then
                local java_version_file_path = client.root_dir .. '/' .. java_version_file
                local default_java_version = M.get_default_java_version() or M.get_default_java_version_from_config()

                if default_java_version then
                    local java_version_file_handle = assert(io.open(java_version_file_path, 'w'))
                    java_version_file_handle:write(default_java_version)
                    java_version_file_handle:flush()
                    java_version_file_handle:close()
                end
            end
        end
    end
end

M.get_default_java_version_from_file = function(client)
    local java_version_file_path = client.root_dir .. '/' .. java_version_file

    if (vim.uv or vim.loop).fs_stat(java_version_file_path) then
        local java_version_file_handle = assert(io.open(java_version_file_path, 'r'))
        local default_java_version = java_version_file_handle:read('*all')
        java_version_file_handle:close()

        return default_java_version
    end

    return nil
end

M.set_default_java_version_from_file = function(java_config, client)
    local java_version_file_path = client.root_dir .. '/' .. java_version_file

    if (vim.uv or vim.loop).fs_stat(java_version_file_path) then
        local java_version_file_handle = assert(io.open(java_version_file_path, 'r'))
        local default_java_version = java_version_file_handle:read('*all')
        java_version_file_handle:close()

        return M.update_default_java(java_config, default_java_version)
    end

    return java_config
end

M.get_default_java_version_from_config = function()
    for _, runtime in ipairs(env.lsp.jdtls.settings.java.configuration.runtimes) do
        if runtime.default then
            return runtime.name
        end
    end

    return nil
end

M.get_default_java_version = function()
    local buf_client = vim.lsp.get_clients({ name = 'jdtls', bufnr = 0 })[1]
    local current_config = published_configuration[buf_client.root_dir]

    for _, runtime in ipairs(current_config.java.configuration.runtimes) do
        if runtime.default then
            return runtime.name
        end
    end

    return nil
end

M.get_java_versions = function()
    return vim.tbl_map(function(runtime)
        return runtime.name
    end, env.lsp.jdtls.settings.java.configuration.runtimes)
end

return M
