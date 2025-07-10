local has_haunt, haunt = pcall(require, 'haunt')

local _M = {}
local M = {}
local dependency_classpath = {}
local updating_classpath = {}

local mvn_executable = 'mvn'

M.can_setup = function()
    return vim.fn.executable(mvn_executable)
end

M.setup = function(bufnr, root_dir, java_home)
    if not M.can_setup() then
        return
    end

    vim.keymap.set({ 'n', 'v' }, '<leader>mmc', function()
        M.compile(root_dir, java_home)
    end, { buffer = bufnr, remap = true, desc = 'Compile Maven Project' })

    vim.keymap.set({ 'n', 'v' }, '<leader>mmd', function()
        dependency_classpath[root_dir] = nil
        M.get_dependency_classpath(root_dir, java_home)
    end, { buffer = bufnr, remap = true, desc = 'Update Dependency classpath' })
end

M.compile = function(root_dir, java_home)
    vim.notify('Compiling Project...')

    local compile_cmd = {
        mvn_executable,
        '-B',
        '-f',
        root_dir,
        'compile',
        'test-compile'
    }

    vim.system(compile_cmd, { env = { ['JAVA_HOME'] = java_home } }, function(compile_result)
        if compile_result.code ~= 0 then
            vim.notify('Failed to compile project!', vim.log.levels.ERROR)
            vim.notify(compile_result.stderr, vim.log.levels.ERROR)
            return
        end
        vim.notify('Project compiled!')
    end)
end

M.get_dependency_classpath = function(root_dir, java_home)
    if not dependency_classpath[root_dir] then
        updating_classpath[root_dir] = true
        vim.notify('Updating classpath...')

        local classpath_cmd = {
            mvn_executable,
            '-B',
            '-f',
            root_dir,
            'dependency:build-classpath'
        }

        vim.system(classpath_cmd, { text = true, env = { ['JAVA_HOME'] = java_home } }, function(classpath_result)
            if classpath_result.code ~= 0 then
                vim.notify(classpath_result.stderr, vim.log.levels.ERROR)
                return
            end

            local classpath_data = ''

            local classpath_result_lines = vim.split(classpath_result.stdout, '\n', { plain = true, trimempty = true })

            for i, line in ipairs(classpath_result_lines) do
                if string.find(line, 'Dependencies classpath:', 0, true) ~= nil then
                    classpath_data = classpath_result_lines[i + 1]
                    break
                end
            end

            dependency_classpath[root_dir] = classpath_data

            updating_classpath[root_dir] = false
            vim.notify('Classpath is ready!')
        end)
    end

    return dependency_classpath[root_dir]
end

M.test = function(test_descriptor, root_dir, java_home)
    if has_haunt then
        local test_cmd = table.concat(
            { _M.build_java_home(java_home), mvn_executable, '-f ' .. root_dir, 'test', '-Dtest=' ..
            test_descriptor }, ' ')

        haunt.term({
            fargs = {
                vim.o.shell,
                '-c',
                test_cmd .. '; echo -e "\nPress any button to continue..." && read dummy'
            }
        })
    end
end

_M.build_java_home = function(path)
    return 'JAVA_HOME="' .. path .. '"'
end

return M
