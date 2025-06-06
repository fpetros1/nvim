local submodules = {
    require('fpetros.git.gitsigns'),
    require('fpetros.git.lazygit')
}

local M = {}

M.setup = function()
    for _, submodule in ipairs(submodules) do
        submodule.setup()
    end
end

return M
