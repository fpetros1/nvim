local has_blink, blink = pcall(require, 'blink.cmp')

local M = {}

M.can_setup = function()
    return has_blink
end

M.setup = function()
    if not M.can_setup() then
        return vim.lsp.protocol.make_client_capabilities()
    end

    blink.setup({
        keymap = { preset = 'enter' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true
                }
            },
            accept = {
                create_undo_point = true,
                auto_brackets = { enabled = true },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
                window = {
                    border = 'rounded',
                    scrollbar = false
                },
            },
            ghost_text = { enabled = true },
            menu = {
                border = 'rounded',
                scrollbar = false
            },
        },
        cmdline = { sources = {} },
        signature = {
            enabled = true,
            window = {
                border = 'rounded'
            }
        }
    })

    if vim.g.colors_name == 'eldritch' then
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { fg = '#ebfafa', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#37f499', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { fg = '#ebfafa', bg = '#323449' })
        vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { fg = '#ebfafa', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = '#37f499', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { fg = '#ebfafa', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = '#37f499', bg = '#212337' })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter', { fg = '#04d1f9', bg = '#212337' })
    end

    return blink.get_lsp_capabilities()
end

return M
