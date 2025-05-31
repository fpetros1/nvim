local has_haunt, haunt = pcall(require, 'haunt')

local _M = {}
local M = {}
local dependency_classpath = {}

local mvn_executable = 'mvn'

M.get_dependency_classpath = function(root_dir, java_home)
    if not dependency_classpath[root_dir] then
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

            vim.notify('Classpath is ready')
        end)
    end

    return dependency_classpath[root_dir]
end

M.test = function(test_descriptor, java_home)
    if has_haunt then
        local test_cmd = table.concat({ _M.build_java_home(java_home), mvn_executable, 'test', '-Dtest=' ..
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
