vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

options = { noremap = true }

-- Change panes on vim leader mappings
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', options)
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', options)
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', options)
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', options)

-- Split with leader
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', options)
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', options)

-- Toggle Interface
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', options)
