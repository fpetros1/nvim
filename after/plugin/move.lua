local hasMove, move = pcall(require, 'move')

if hasMove then
    move.setup({})

    local opts = { noremap = false, silent = true }
    vim.keymap.set('n', '<C-Up>', ':MoveLine(-1)<CR>', opts)
    vim.keymap.set('n', '<C-Down>', ':MoveLine(1)<CR>', opts)
end
