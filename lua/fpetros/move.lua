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
    vim.keymap.set('n', '<S-Up>', ':MoveLine(-1)<CR>', opts)
    vim.keymap.set('n', '<S-Down>', ':MoveLine(1)<CR>', opts)
    vim.keymap.set('v', '<S-Up>', ':MoveBlock(-1)<CR>', opts)
    vim.keymap.set('v', '<S-Down>', ':MoveBlock(1)<CR>', opts)
end

return M
