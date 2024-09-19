local telescope = require('telescope')
local builtin = require('telescope.builtin')

local config = {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = { height = 0.95, width = 0.9 },
        path_display = { "smart" },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
}

if vim.g.neovide then
    config.defaults.winblend = 100
end


telescope.setup(config)

vim.keymap.set('n', '<leader><leader>', builtin.find_files)
vim.keymap.set('n', '<leader>P', function() builtin.find_files({ no_ignore = true }) end)
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>Telescope live_grep<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', options)

require("telescope").load_extension("ui-select")
