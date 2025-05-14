local has_trouble, trouble = pcall(require, 'trouble')

if has_trouble then
    trouble.setup({})

    vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>Trouble diagnostics<cr>",
        { silent = true, noremap = true }
    )
end
