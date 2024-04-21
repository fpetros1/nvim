local lsp = require("lsp-zero")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local types = require("cmp.types")
local str = require("cmp.utils.str")
local lspkind = require('lspkind')

require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt", "vim" },
})

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

lsp.preset("recommended")

lsp.on_attach()

lsp.ensure_installed({
    'jdtls',
    'tsserver',
    'rust_analyzer',
    'bashls',
    'lua_ls',
    'jsonls',
    'pylsp'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.setup_nvim_cmp({
    mapping = lsp.defaults.cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)


lsp.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 5000
    },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['tsserver'] = { 'ts', 'js', 'typescript', 'javascript' },
        ['bashls'] = { 'bash', 'sh', 'shell' },
        ['jsonls'] = { 'json' },
        ['rust_analyzer'] = { 'rust' },
        ['pylsp'] = { 'python' }
    }
})

lsp.skip_server_setup({ 'jdtls' })

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        highlight_whole_line = false,
        only_current_line = true
    }
})

require("lsp_lines").setup()

local cmpConfig = {
    window = {
        completion = {
            border = "rounded",
        },
        documentation = {
            border = "rounded",
        }
    },

    formatting = {
        fields = {
            cmp.ItemField.Kind,
            cmp.ItemField.Abbr,
            cmp.ItemField.Menu,
        },
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            before = function(entry, vim_item)
                -- Get the full snippet (and only keep first line)
                local word = entry:get_insert_text()
                if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                    word = vim.lsp.util.parse_snippet(word)
                end

                word = str.oneline(word)

                if
                    entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                    and string.sub(vim_item.abbr, -1, -1) == "~"
                then
                    word = word .. "~"
                end
                vim_item.abbr = word

                return vim_item
            end,
        }),
    }
}

if vim.g.neovide then
    cmpConfig.window.completion.winblend = 100
    cmpConfig.window.documentation.winblend = 100
end

cmp.setup(cmpConfig)
