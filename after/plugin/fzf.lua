local fzf = require('fzf-lua')

fzf.register_ui_select()

fzf.setup({
    'telescope',
    winopts = {
        preview = {
            layout = 'vertical'
        }
    }
})

vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Fzf Live Grep" })
vim.keymap.set("n", "<leader>\\", fzf.marks, { desc = "Fzf Marks" })
