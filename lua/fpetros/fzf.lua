local has_fzf, fzf = pcall(require, 'fzf-lua')

local M = {}

M.can_setup = function()
    return has_fzf
end

M.setup = function()
    fzf.register_ui_select()

    fzf.setup({
        { 'default-title' },
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

    vim.keymap.set("n", "<leader><leader>", function()
        fzf.files()
    end, { desc = "Fzf Files" })

    vim.keymap.set("n", "<leader>/", function()
        fzf.live_grep()
    end, { desc = "Fzf Live Grep" })

    vim.keymap.set("n", "<leader>\\", function()
        fzf.marks()
    end, { desc = "Fzf Marks" })

    vim.keymap.set("n", "<leader>ggs", function()
        fzf.git_status()
    end, { desc = "Fzf Git Status" })

    vim.keymap.set("n", "<leader>ggc", function()
        fzf.git_commits()
    end, { desc = "Fzf Git Commits" })

    vim.keymap.set("n", "<leader>ggb", function()
        fzf.git_branches()
    end, { desc = "Fzf Git Branches" })

    vim.keymap.set("n", "<leader>ggB", function()
        fzf.git_blame()
    end, { desc = "Fzf Git Blame" })
end

return M
