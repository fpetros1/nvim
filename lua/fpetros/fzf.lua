local has_fzf, fzf = pcall(require, 'fzf-lua')
local filemanager  = require('fpetros.filemanager')

local M            = {}

M.can_setup        = function()
    return has_fzf
end

M.setup            = function()
    fzf.register_ui_select()

    fzf.setup({
        'default-title',
        winopts = {
            height = 0.99,
            width = 0.99,
            preview = {
                layout = 'vertical',
                vertical = "up:70%"
            }
        },
        fzf_colors = false,
    })

    vim.keymap.set("n", "<leader><leader>", function()
        filemanager.close_if_open(true)
        fzf.files()
    end, { desc = "Fzf Files" })

    vim.keymap.set("n", "<leader>[", function()
        filemanager.close_if_open(true)
        vim.cmd('FzfLua resume')
    end, { desc = "Fzf Files Resume" })

    vim.keymap.set("n", "<leader>/", function()
        filemanager.close_if_open(true)
        fzf.live_grep()
    end, { desc = "Fzf Live Grep" })

    vim.keymap.set("n", "<leader>\\", function()
        filemanager.close_if_open(true)
        fzf.marks()
    end, { desc = "Fzf Marks" })

    vim.keymap.set("n", "<leader>ggs", function()
        filemanager.close_if_open(true)
        fzf.git_status()
    end, { desc = "Fzf Git Status" })

    vim.keymap.set("n", "<leader>ggc", function()
        filemanager.close_if_open(true)
        fzf.git_commits()
    end, { desc = "Fzf Git Commits" })

    vim.keymap.set("n", "<leader>ggb", function()
        filemanager.close_if_open(true)
        fzf.git_branches()
    end, { desc = "Fzf Git Branches" })

    vim.keymap.set("n", "<leader>ggB", function()
        filemanager.close_if_open(true)
        fzf.git_blame()
    end, { desc = "Fzf Git Blame" })
end

return M
