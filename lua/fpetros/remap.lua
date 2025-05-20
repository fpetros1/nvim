local M = {}

M.setup = function()
    vim.g.mapleader = " "

    vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
    vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
    vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]])

    vim.keymap.set("n", "q", "<nop>")
    vim.keymap.set("n", "Q", "<nop>")

    vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

    local options = { noremap = true }

    -- Change panes on vim leader mappings
    vim.api.nvim_set_keymap("n", "<leader>o", '<C-o>', options)
    vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', options)
    vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', options)
    vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', options)
    vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', options)

    -- Split with leader
    vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', options)
    vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', options)
end

return M
