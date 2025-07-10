local env = require('fpetros.config.env')
local mvn = require('fpetros.lsp.java.mvn')
local os_utils = require('fpetros.utils.os_utils')
local has_fzf, fzf = pcall(require, 'fzf-lua')
local has_jdtls, jdtls = pcall(require, 'jdtls')

local _M = {}
local M = {}

local java_version_file = '.java.version'
local cached_default_java_version = {}
local runtimes = {}

M.get_dependency_classpath = function(root_dir)
    return mvn.get_dependency_classpath(root_dir, M.get_default_java_version(root_dir).path)
end

M.update_default_java = function(java_config, default_java_version, root_dir)
    local has_default = false

    for _, runtime in ipairs(runtimes[root_dir]) do
        local is_default = runtime.name == default_java_version
        if is_default then
            cached_default_java_version[root_dir] = runtime
            runtime.default = true
            has_default = true
            goto continue
        end
        runtime.default = false
        ::continue::
    end

    if not has_default and #runtimes[root_dir] > 0 then
        runtimes[root_dir].java.configuration.runtimes[1].default = true
    end

    if java_config then
        java_config.java.configuration.runtimes = vim.deepcopy(runtimes[root_dir])
    end

    M.update_version_file(root_dir)

    return java_config
end

M.update_version_file = function(root_dir)
    local java_version_file_path = root_dir .. '/' .. java_version_file
    local default_java_version = M.get_default_java_version(root_dir) or
        M.get_default_java_version_from_config()

    if default_java_version then
        local java_version_file_handle = assert(io.open(java_version_file_path, 'w'))
        java_version_file_handle:write(default_java_version.name)
        java_version_file_handle:flush()
        java_version_file_handle:close()
    end
end

M.get_default_java_version_from_file = function(root_dir)
    local java_version_file_path = root_dir .. '/' .. java_version_file

    if (vim.uv or vim.loop).fs_stat(java_version_file_path) then
        local java_version_file_handle = assert(io.open(java_version_file_path, 'r'))
        local default_java_version = java_version_file_handle:read('*all')
        java_version_file_handle:close()

        return default_java_version
    end

    return nil
end

M.set_default_java_version_from_file = function(java_config, root_dir)
    local java_version_file_path = root_dir .. '/' .. java_version_file

    if (vim.uv or vim.loop).fs_stat(java_version_file_path) then
        local java_version_file_handle = assert(io.open(java_version_file_path, 'r'))
        local default_java_version = java_version_file_handle:read('*all')
        java_version_file_handle:close()

        return M.update_default_java(java_config, default_java_version, root_dir)
    end

    M.update_default_java(java_config, M.get_default_java_version_from_config().name, root_dir)

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

M.choose_java_version = function(root_dir)
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
                    M.update_default_java(nil, selected[1], root_dir)
                    M.update_version_file(root_dir)
                    if has_jdtls then
                        jdtls.set_runtime(selected[1])
                    end
                end
            }
        })
    end
end

--

M.get_root_dir = function()
    return vim.fs.root(0, { '.git', 'pom.xml', 'mvnw', 'gradlew', 'build.gradle' })
end

M.init_runtimes = function(java_config, root_dir)
    runtimes[root_dir] = vim.deepcopy(java_config.java.configuration.runtimes)
end

M.build_jdtls_cmd = function(root_dir)
    local lombok_path = _M.get_lombok_jar()
    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local lsp_path = _M.get_jdtls_jar()

    return {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. lombok_path,
        '-jar', lsp_path,
        '-configuration', _M.get_config_folder(),
        '-data', _M.get_project_workspace(project_name)
    }
end

M.get_java_debug_bundle = function()
    return vim.split(vim.fn.glob(vim.fn.stdpath('data') .. '/mason/share/java-debug-adapter/*.jar'), '\n')
end

M.get_java_test_bundle = function()
    return vim.split(vim.fn.glob(vim.fn.stdpath('data') .. '/mason/share/java-test/*.jar'), '\n')
end

_M.get_lombok_jar = function()
    return vim.fn.stdpath("data") .. "/mason/packages/lombok/lombok.jar"
end

_M.get_jdtls_jar = function()
    return vim.fn.stdpath('data') ..
        '/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar'
end

_M.get_project_workspace = function(project_name)
    return vim.fn.stdpath('data') .. '/workspace/jdtls/' .. project_name
end

_M.get_config_folder = function()
    local _, os_arch = os_utils.get_os_params()
    local config_folder = vim.fn.stdpath('data') .. '/mason/share/jdtls/config'

    if os_arch == 'arm' then
        config_folder = config_folder .. '/arm'
    end

    return config_folder
end

_M.get_root_dir_from_client = function(client)
    return client.root_dir or client['Root directory']
end

return M, _M
