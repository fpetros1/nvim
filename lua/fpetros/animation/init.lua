local submodules = {
    require('fpetros.animation.neoscroll'),
    require('fpetros.animation.smear'),
}

local M = {}

M.setup = function()
    for _, submodule in ipairs(submodules) do
        submodule.setup()
    end
end

return M
