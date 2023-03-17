options = { noremap = true }

-- Change panes on vim leader mappings
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', options)
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', options)
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', options)
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', options)

-- Split with leader
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', options)
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', options)

-- Toggle Interface
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', options)

