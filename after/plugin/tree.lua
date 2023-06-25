require 'nvim-tree'.setup()

vim.api.nvim_set_keymap('n', '<leader>N', ':NvimTreeToggle <CR>', { noremap = true })
