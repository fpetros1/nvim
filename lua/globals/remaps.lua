options = { noremap = true }

-- Change panes on vim leader mappings
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', options)
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', options)
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', options)
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', options)

-- Split with leader
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', options)
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', options)

-- Toggle Interface
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', options)

