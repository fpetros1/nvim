local fzf = require('fzf-lua')

fzf.register_ui_select()

fzf.setup({
    'telescope',
    winopts = {
        preview = {
            layout = 'vertical'
        }
    }
})


vim.keymap.set("n", "<leader>ca", function()
    fzf.lsp_code_actions({
        winopts = {
            preview = {
                layout = 'vertical',
            }
        },
    })
end, { desc = "Fzf Code Actions" })


vim.keymap.set("n", "<leader>fr", function()
    fzf.lsp_references({
        winopts = {
            preview = {
                layout = 'vertical',
            }
        },
    })
end, { desc = "Fzf find References" })


vim.keymap.set("n", "<leader>fi", function()
    fzf.lsp_implementations({
        winopts = {
            preview = {
                layout = 'vertical',
            }
        },
    })
end, { desc = "Fzf Find Implementations" })

vim.keymap.set("n", "<leader>fd", function()
    fzf.lsp_definitions({
        winopts = {
            preview = {
                layout = 'vertical',
            }
        },
    })
end, { desc = "Fzf Find Definitions" })

vim.keymap.set("n", "<leader>fc", function()
    fzf.lsp_incoming_calls({
        winopts = {
            preview = {
                layout = 'vertical',
            }
        },
    })
end, { desc = "Fzf Incoming Calls" })


vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Fzf Live Grep" })
vim.keymap.set("n", "<leader>\\", fzf.marks, { desc = "Fzf Marks" })
