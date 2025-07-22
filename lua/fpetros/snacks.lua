local has_snacks, snacks = pcall(require, 'snacks')

local M = {}

M.can_setup = function()
    return has_snacks
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    vim.keymap.set("n", "<leader>qq", function()
        snacks.bufdelete()
    end, { noremap = true, desc = "Quit" })

    vim.keymap.set("n", "<leader>qa", function()
        snacks.bufdelete()
    end, { noremap = true, desc = "Quit All" })

    vim.keymap.set("n", "<C-j>", function()
        snacks.words.jump(1, true)
    end, { noremap = true, desc = "Jump Words" })
end

return M
