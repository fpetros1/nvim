local M = {}

M.setup = function()
    require('fpetros.git.gitsigns').setup()
    require('fpetros.git.lazygit').setup()
end

return M
