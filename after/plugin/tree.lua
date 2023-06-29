require 'nvim-tree'.setup({
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
    }
})

vim.api.nvim_set_keymap('n', '<leader>N', ':NvimTreeToggle <CR>', { noremap = true })
