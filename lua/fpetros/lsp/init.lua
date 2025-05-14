local has_lspconfig, _ = pcall(require, 'lspconfig')
local has_mason, mason = pcall(require, 'mason')
local has_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
local has_fzf, fzf = pcall(require, 'fzf-lua')
local diagnostic = require('fpetros.diagnostic')
local completion = require('fpetros.completion')
local java_lsp = require('fpetros.lsp.java')
local formatting = require('fpetros.formatting')

if has_lspconfig and has_mason and has_mason_lsp and has_fzf then
    local ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'lua_ls',
        'jsonls',
        'pylsp',
        'yamlls'
    }

    mason.setup({
        registries = {
            "github:fpetros1/mason-registry",
            "github:mason-org/mason-registry",
        }
    })

    local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "<leader>ca", function() fzf.lsp_code_actions({}) end, { desc = "LSP Code Actions" })
        vim.keymap.set("n", "<leader>fr", function() fzf.lsp_references({}) end, { desc = "LSP find References" })
        vim.keymap.set("n", "gd", function() fzf.lsp_definitions({}) end, { desc = "LSP Find Definitions" })
        vim.keymap.set("n", "gi", function() fzf.lsp_implementations({}) end, { desc = "LSP Find Implementations" })
        vim.keymap.set("n", "gD", function() fzf.lsp_declarations({}) end, { desc = "LSP Declarations" })

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

        vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
        vim.keymap.set("v", "<leader>ff", function() vim.lsp.buf.format() end, opts)

        formatting.set_server({ client.name }, nil)
    end

    diagnostic.setup()

    local capabilities = completion.setup()

    vim.lsp.config("*", {
        on_attach = lsp_attach,
        capabilities = capabilities
    })

    local ensure_installed_java = java_lsp.setup(capabilities, lsp_attach)
    vim.list_extend(ensure_installed, ensure_installed_java)

    vim.lsp.config("bashls", {
        on_attach = lsp_attach,
        filetypes = { 'sh', 'zsh', 'bash' },
        capabilities = capabilities
    })

    mason_lsp.setup({
        ensure_installed = ensure_installed,
    })

    formatting.setup()
end
