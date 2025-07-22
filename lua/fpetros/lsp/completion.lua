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
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },
        keymap = {
            --super-tab
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },

            ['<Tab>'] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                'snippet_forward',
                'fallback'
            },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
        },
        completion = {
            list = {
                selection = {
                    preselect = true,
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
        --        cmdline = { sources = {} },
        signature = {
            enabled = true,
            window = {
                border = 'rounded'
            }
        }
    })

    return blink.get_lsp_capabilities()
end

return M
