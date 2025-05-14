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
            accept = {
                create_undo_point = true,
                auto_brackets = { enabled = true },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
            },
            ghost_text = { enabled = true },
        },
        cmdline = { sources = {} },
        signature = { enabled = true }
    })

    return blink.get_lsp_capabilities()
end

return M
