local has_noice, noice = pcall(require, 'noice')

local M = {}

M.can_setup = function()
    return has_noice
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    local config = {
        messages = {
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = "virtualtext"
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
            progress = {
                enabled = true,
                view = "virtualtext",
                throttle = 1000, -- frequency to update lsp progress message
            },
            signature = {
                enabled = false
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

    noice.setup(config)

    vim.keymap.set('n', '<leader>cc', function() vim.cmd('NoiceDismiss') end, { desc = "Dismiss Warnings/Errors" })
end

return M
