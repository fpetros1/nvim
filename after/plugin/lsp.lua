require('mason').setup({})
local mason_lspconfig = require('mason-lspconfig')
local lsp = require("lsp-zero")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
local types = require("cmp.types")
local str = require("cmp.utils.str")
local lspkind = require('lspkind')

local lsp_attach = function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts)
    --vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt", "vim" },
})

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

mason_lspconfig.setup({
    ensure_installed = {
        'jdtls',
        'ts_ls',
        'rust_analyzer',
        'bashls',
        'lua_ls',
        'jsonls',
        'pylsp'
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        jdtls = lsp.noop,
    }
})

lsp.extend_lspconfig({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    },
})

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
        ['pylsp'] = { 'python' },
        ['gopls'] = { 'go' }
    }
})

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
    sources = {
        { name = 'nvim_lsp' },
    },
    window = {
        completion = {
            border = "rounded",
        },
        documentation = {
            border = "rounded",
        }
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        ['<C-e>'] = cmp_action.toggle_completion(),

        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        ['<C-f>'] = cmp.mapping.scroll_docs(-5),
        ['<C-d>'] = cmp.mapping.scroll_docs(5),
    }),
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
