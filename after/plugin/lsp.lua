require('mason').setup({})
local mason_lspconfig = require('mason-lspconfig')
local lsp = require("lsp-zero")
local fzf = require('fzf-lua')
local java = require('java')
local env_config = require('fpetros.env-config')
local has_cmp, cmp = pcall(require, 'cmp')
local has_blink, blink = pcall(require, 'blink.cmp')
local google_java_format = require('fpetros.google-java-format')

-- require('nvim-autopairs').setup({
--     disable_filetype = { "TelescopePrompt", "vim" }
-- })


local lsp_attach = function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "<leader>ca", function() fzf.lsp_code_actions({}) end, { desc = "LSP Code Actions" })
    vim.keymap.set("n", "<leader>fr", function() fzf.lsp_references({}) end, { desc = "LSP find References" })
    vim.keymap.set("n", "gd", function() fzf.lsp_definitions({}) end, { desc = "LSP Find Definitions" })
    vim.keymap.set("n", "gi", function() fzf.lsp_implementations({}) end, { desc = "LSP Find Implementations" })
    vim.keymap.set("n", "gD", function() fzf.lsp_declarations({}) end, { desc = "LSP Declarations" })

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    if client.name == 'jdtls' then
        google_java_format.setup_formatter({ buf = bufnr })

        vim.keymap.set("n", "<leader>tt",
            "<cmd>lua require('java').test.run_current_method()<CR>", opts)
        vim.keymap.set("n", "<leader>tT",
            "<cmd>lua require('java').test.run_current_class()<CR>", opts)
        vim.keymap.set("n", "<leader>tR",
            "<cmd>lua require('java').test.view_last_report()<CR>", opts)
    end
end

if has_blink then
    blink.setup({
        keymap = { preset = 'enter' },
        highlight = {
            use_nvim_cmp_as_default = true,
        },
        nerd_font_variant = 'mono',
        accept = { auto_brackets = { enabled = true } },
        trigger = { signature_help = { enabled = true } }
    })
end

java.setup({})

lsp.extend_lspconfig({
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    },
})

mason_lspconfig.setup({
    ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'bashls',
        'lua_ls',
        'jsonls',
        'pylsp',
    },
    handlers = {
        function(server_name)
            local server = require('lspconfig')[server_name]
            local config = {}
            if has_blink then
                config.capabilities = blink.get_lsp_capabilities(nil, true)
            end
            server.setup(config)
        end,
        jdtls = function()
            local config = {
                settings = {
                    java = {
                        configuration = {
                            runtimes = env_config.java.runtimes
                        }
                    }
                }
            }
            if has_blink then
                config.capabilities = blink.get_lsp_capabilities(nil, true)
            end
            require('lspconfig').jdtls.setup(config)
        end,
        bashls = function()
            require('lspconfig').bashls.setup({
                filetypes = { 'sh', 'zsh', 'bash' }
            })
        end
    }
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
        ['gopls'] = { 'go' },
        ['google-java-format'] = { 'java' }
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

if has_cmp then
    local lspkind = require('lspkind')
    local str = require("cmp.utils.str")
    local cmp_action = lsp.cmp_action()
    local types = require("cmp.types")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            {
                name = 'cmdline',
                option = {
                    ignore_cmds = { 'Man', '!' }
                }
            }
        })
    })

    cmp.setup({
        preselect = 'item',
        completion = {
            completeopt = 'menu,menuone,noinsert'
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sources = {
            { name = 'nvim_lsp', keyword_length = 2 },
            { name = 'buffer',   keyword_length = 2 },
            { name = 'path',     keyword_length = 2 },
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-e>'] = cmp_action.toggle_completion(),
            ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            ['<C-u>'] = cmp.mapping.scroll_docs(-5),
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
                ellipsis_char = '...',
                before = function(entry, vim_item)
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
                end
            })
        }
    })
end
