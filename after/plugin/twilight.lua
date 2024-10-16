local has_twilight, twilight = pcall(require, 'twilight')

if has_twilight then
    twilight.setup({})

    vim.keymap.set('n', '<C-w>', '<cmd>Twilight<CR>', { desc = 'Toggles Twilight'})
end
