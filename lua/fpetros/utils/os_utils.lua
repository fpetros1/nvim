local M = {}

M.get_os_params = function()
    local raw_os_name, raw_arch_name = '', ''

    if jit and jit.os and jit.arch then
        raw_os_name = jit.os
        raw_arch_name = jit.arch
    else
        if package.config:sub(1, 1) == '\\' then
            local env_OS = os.getenv('OS')
            local env_ARCH = os.getenv('PROCESSOR_ARCHITECTURE')
            if env_OS and env_ARCH then
                raw_os_name, raw_arch_name = env_OS, env_ARCH
            end
        else
            raw_os_name = io.popen('uname -s', 'r'):read('*l')
            raw_arch_name = io.popen('uname -m', 'r'):read('*l')
        end
    end

    raw_os_name = (raw_os_name):lower()
    raw_arch_name = (raw_arch_name):lower()

    local os_patterns = {
        ['windows'] = 'Windows',
        ['linux']   = 'Linux',
        ['osx']     = 'Mac',
        ['mac']     = 'Mac',
        ['darwin']  = 'Mac',
        ['^mingw']  = 'Windows',
        ['^cygwin'] = 'Windows',
        ['bsd$']    = 'BSD',
        ['sunos']   = 'Solaris',
    }

    local arch_patterns = {
        ['^x86$']           = 'x86',
        ['i[%d]86']         = 'x86',
        ['amd64']           = 'x86_64',
        ['x86_64']          = 'x86_64',
        ['x64']             = 'x86_64',
        ['power macintosh'] = 'powerpc',
        ['^arm']            = 'arm',
        ['^mips']           = 'mips',
        ['i86pc']           = 'x86',
    }

    local os_name, arch_name = 'unknown', 'unknown'

    for pattern, name in pairs(os_patterns) do
        if raw_os_name:match(pattern) then
            os_name = name
            break
        end
    end
    for pattern, name in pairs(arch_patterns) do
        if raw_arch_name:match(pattern) then
            arch_name = name
            break
        end
    end
    return os_name, arch_name
end

return M
