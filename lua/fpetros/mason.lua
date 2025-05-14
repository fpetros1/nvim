local has_mason, mason = pcall(require, 'mason')
local M = {}

M.can_setup = function()
    return has_mason
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    mason.setup({
        registries = {
            "github:fpetros1/mason-registry",
            "github:mason-org/mason-registry",
        }
    })
end

return M
