local has_snacks, snacks = pcall(require, 'snacks')
local filemanager = require('fpetros.filemanager')

local M = {}

M.can_setup = function()
    return has_snacks
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    vim.keymap.set('n', '<leader>ggg', function()
        filemanager.close_if_open(true)
        snacks.lazygit()
    end, { desc = 'Open Lazygit' })
end

return M
