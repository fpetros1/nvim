local set = require('fpetros.gui.set')
local neovide = require('fpetros.gui.neovide')

local M = {}

M.setup = function()
    set.setup()
    neovide.setup()
end

return M
