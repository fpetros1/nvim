local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.9, preview_height = 0.6 }
    }
}

vim.keymap.set('n', '<leader><leader>', builtin.find_files)
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>Telescope live_grep<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', options)
