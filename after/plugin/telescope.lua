local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>Telescope live_grep<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', options)
