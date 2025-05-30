local env = require('fpetros.config.env')
local has_fzf, fzf = pcall(require, 'fzf-lua')

local M = {}

local java_version_file = '.java.version'
local cached_default_java_version = {}
local published_configuration = {}
local dependency_classpath = {}

M.register_published_config = function(root_dir, config)
    published_configuration[root_dir] = config
end

M.get_current_config = function(root_dir)
    return published_configuration[root_dir]
end

M.init_dependency_classpath = function(root_dir)
    if not dependency_classpath[root_dir] then
        local java_home = M.build_java_home(root_dir)

        local classpath_cmd = {
            vim.o.shell,
            '-c',
            java_home ..
            ' mvn -B -f ' ..
            root_dir ..
            ' dependency:build-classpath | sed -n "/Dependencies classpath:/,/[INFO]/p" | tail -n -1'
        }

        vim.system(classpath_cmd, { text = true }, function(classpath_result)
            if classpath_result.code ~= 0 then
                vim.notify(classpath_result.stderr, vim.log.levels.ERROR)
                return
            end

            dependency_classpath[root_dir] = string.sub(classpath_result.stdout, 1,
                #classpath_result.stdout - 1)
        end)
    end
end

M.get_dependency_classpath = function(root_dir)
    return dependency_classpath[root_dir]
end

M.update_default_java = function(java_config, default_java_version, root_dir)
    local has_default = false

    for _, runtime in ipairs(java_config.java.configuration.runtimes) do
        local is_default = runtime.name == default_java_version
        if is_default then
            cached_default_java_version[root_dir] = runtime
            runtime.default = true
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
                local default_java_version = M.get_default_java_version(client.root_dir) or
                    M.get_default_java_version_from_config()

                if default_java_version then
                    local java_version_file_handle = assert(io.open(java_version_file_path, 'w'))
                    java_version_file_handle:write(default_java_version.name)
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

        return M.update_default_java(java_config, default_java_version, client.root_dir)
    end

    return java_config
end

M.get_default_java_version_from_config = function()
    for _, runtime in ipairs(env.lsp.jdtls.settings.java.configuration.runtimes) do
        if runtime.default then
            return runtime
        end
    end

    return nil
end

M.get_default_java_version = function(root_dir)
    return cached_default_java_version[root_dir]
end

M.get_java_versions = function()
    return vim.tbl_map(function(runtime)
        return runtime.name
    end, env.lsp.jdtls.settings.java.configuration.runtimes)
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
                                current_config = M.update_default_java(current_config, selected[1], buf_client.root_dir)
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

M.build_java_home = function(root_dir)
    return 'JAVA_HOME="' .. M.get_default_java_version(root_dir).path .. '"'
end

return M
