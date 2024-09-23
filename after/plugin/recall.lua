local recall = require("recall")

recall.setup({})

vim.keymap.set("n", "m", function() end, { silent = true })
vim.keymap.set("n", "<leader>mm", recall.toggle, { noremap = true, silent = true, desc = "Create Mark" })
vim.keymap.set("n", "<leader>mn", recall.goto_next, { noremap = true, silent = true, desc = "Next Mark" })
vim.keymap.set("n", "<leader>mp", recall.goto_prev, { noremap = true, silent = true, desc = "Previous Mark" })
vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true, desc = "Clear Marks" })
