local submodules = {
    require('fpetros.gui.set'),
    require('fpetros.gui.neovide')
}

local M = {}

M.setup = function()
    for _, submodule in ipairs(submodules) do
        submodule.setup()
    end
end

return M
