local env = require('fpetros.config.env')

local M = {}

M.setup = function()
    vim.opt.guifont = env.gui.font
    vim.opt.linespace = env.gui.linespace
end

return M
