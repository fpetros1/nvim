local fzf = require('fzf-lua')

fzf.register_ui_select()

fzf.setup({
    'telescope',
    winopts = {
        height = 0.99,
        width = 0.99,
        preview = {
            layout = 'vertical',
            vertical = "up:70%"
        }
    }
})

vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Fzf Live Grep" })
vim.keymap.set("n", "<leader>\\", fzf.marks, { desc = "Fzf Marks" })

vim.keymap.set("n", "<leader>ggs", fzf.git_status, { desc = "Fzf Git Status" })
vim.keymap.set("n", "<leader>ggc", fzf.git_commits, { desc = "Fzf Git Commits" })
vim.keymap.set("n", "<leader>ggb", fzf.git_branches, { desc = "Fzf Git Branches" })
vim.keymap.set("n", "<leader>ggB", fzf.git_blame, { desc = "Fzf Git Blame" })
