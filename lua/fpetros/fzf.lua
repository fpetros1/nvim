local has_fzf, fzf = pcall(require, 'fzf-lua')
local has_oil, oil = pcall(require, 'oil')

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
        fzf_colors = true,
        keymap = {
            fzf = {
                true,
                ['ctrl-c'] = 'abort'
            }
        }
    })

    local close_oil_if_applicable = function()
        if has_oil then
            oil.close({ exit_if_last_buf = true })
        end
    end

    vim.keymap.set("n", "<leader><leader>", function()
        close_oil_if_applicable()
        fzf.files()
    end, { desc = "Fzf Files" })

    vim.keymap.set("n", "<leader>[", function()
        close_oil_if_applicable()
        vim.cmd('FzfLua resume')
    end, { desc = "Fzf Files Resume" })

    vim.keymap.set("n", "<leader>/", function()
        close_oil_if_applicable()
        fzf.live_grep()
    end, { desc = "Fzf Live Grep" })

    vim.keymap.set("n", "<leader>\\", function()
        close_oil_if_applicable()
        fzf.marks()
    end, { desc = "Fzf Marks" })

    vim.keymap.set("n", "<leader>ggs", function()
        close_oil_if_applicable()
        fzf.git_status()
    end, { desc = "Fzf Git Status" })

    vim.keymap.set("n", "<leader>ggc", function()
        close_oil_if_applicable()
        fzf.git_commits()
    end, { desc = "Fzf Git Commits" })

    vim.keymap.set("n", "<leader>ggb", function()
        close_oil_if_applicable()
        fzf.git_branches()
    end, { desc = "Fzf Git Branches" })

    vim.keymap.set("n", "<leader>ggB", function()
        close_oil_if_applicable()
        fzf.git_blame()
    end, { desc = "Fzf Git Blame" })
end

return M
