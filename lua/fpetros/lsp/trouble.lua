local has_trouble, trouble = pcall(require, 'trouble')

local M = {}

M.can_setup = function()
    return has_trouble
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    trouble.setup({})

    vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>Trouble diagnostics<cr>",
        { silent = true, noremap = true }
    )
end

return M
