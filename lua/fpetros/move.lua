local has_move, move = pcall(require, 'move')

local M = {}

M.can_setup = function()
    return has_move
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    move.setup({})

    local opts = { noremap = false, silent = true, remap = true }
    vim.keymap.set('n', '<C-S-K>', ':MoveLine(-1)<CR>', opts)
    vim.keymap.set('n', '<C-S-J>', ':MoveLine(1)<CR>', opts)
    vim.keymap.set('v', '<C-S-K>', ':MoveBlock(-1)<CR>', opts)
    vim.keymap.set('v', '<C-S-J>', ':MoveBlock(1)<CR>', opts)
end

return M
