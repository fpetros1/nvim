local submodules = {
    require('fpetros.animation.neoscroll')
}

local M = {}

M.setup = function()
    for _, submodule in ipairs(submodules) do
        submodule.setup()
    end
end

return M
