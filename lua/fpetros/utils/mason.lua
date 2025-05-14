local has_mason_reg, mason_reg = pcall(require, 'mason-registry')

local has_necessary_mason_components = function()
    return has_mason_reg
end

local dummy_func = function() end

local M = {}

M.is_installed = has_necessary_mason_components() and function(package)
    local pkg = mason_reg.get_package(package)
    local is_installed = pkg:is_installed()

    if not is_installed then
        return false
    end

    return is_installed
end or dummy_func

M.ensure_installed = has_necessary_mason_components() and function(packages)
    for _, package in ipairs(packages) do
        if not M.is_installed(package) then
            local pkg = mason_reg.get_package(package)

            pkg:install({
                force = true,
            })
        end
    end
end or dummy_func

return M
