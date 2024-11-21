local fzf = require('fzf-lua')
local has_mini_files, mini_files = pcall(require, 'mini.files')

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
    },
    fzf_colors = true
})

local close_mini_files = function()
    if has_mini_files then
        mini_files.close()
    end
end

vim.keymap.set("n", "<leader><leader>", function()
    close_mini_files()
    fzf.files()
end, { desc = "Fzf Files" })

vim.keymap.set("n", "<leader>/", function()
    close_mini_files()
    fzf.live_grep()
end, { desc = "Fzf Live Grep" })

vim.keymap.set("n", "<leader>\\", function()
    close_mini_files()
    fzf.marks()
end, { desc = "Fzf Marks" })

vim.keymap.set("n", "<leader>ggs", function()
    close_mini_files()
    fzf.git_status()
end, { desc = "Fzf Git Status" })

vim.keymap.set("n", "<leader>ggc", function()
    close_mini_files()
    fzf.git_commits()
end, { desc = "Fzf Git Commits" })

vim.keymap.set("n", "<leader>ggb", function()
    close_mini_files()
    fzf.git_branches()
end, { desc = "Fzf Git Branches" })

vim.keymap.set("n", "<leader>ggB", function()
    close_mini_files()
    fzf.git_blame()
end, { desc = "Fzf Git Blame" })
