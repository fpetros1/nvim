local config = {
    messages = {
        view_error = "popup"
    },
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        progress = {
            enabled = true,
            view = "virtualtext",
            throttle = 1000, -- frequency to update lsp progress message
        }
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
}

if vim.g.neovide then
    config.views = {
        notify = {
            win_options = {
                winblend = 100
            }
        },
        split = {
            win_options = {
                winblend = 100
            }
        },
        vsplit = {
            win_options = {
                winblend = 100
            }
        },
        popup = {
            win_options = {
                winblend = 100
            }
        },
        mini = {
            win_options = {
                winblend = 100
            }
        },
        cmdline = {
            win_options = {
                winblend = 100
            }
        },
        cmdline_popup = {
            win_options = {
                winblend = 100
            }
        },
        cmdline_output = {
            win_options = {
                winblend = 100
            }
        },
        messages = {
            win_options = {
                winblend = 100
            }
        },
        confirm = {
            win_options = {
                winblend = 100
            }
        },
        hover = {
            win_options = {
                winblend = 100
            }
        },
        popupmenu = {
            win_options = {
                winblend = 100
            }
        },
    }
end

require("noice").setup(config)
