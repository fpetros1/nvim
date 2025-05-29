local has_lspconfig, _ = pcall(require, 'lspconfig')
local has_mason, _ = pcall(require, 'mason')
local has_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
local has_fzf, fzf = pcall(require, 'fzf-lua')
local diagnostic = require('fpetros.lsp.diagnostic')
local completion = require('fpetros.lsp.completion')
local java_lsp = require('fpetros.lsp.java')
local bash_lsp = require('fpetros.lsp.bash')
local formatting = require('fpetros.lsp.formatting')
local trouble = require('fpetros.lsp.trouble')
local env = require('fpetros.config.env')

local M = {}

M.can_setup = function()
    return has_lspconfig and has_mason and has_mason_lsp and has_fzf and diagnostic.can_setup() and
        completion.can_setup() and trouble.can_setup() and env and env.lsp
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    local ensure_installed = {}

    for server, config in pairs(env.lsp) do
        if config.enabled then
            table.insert(ensure_installed, server)
        end
    end

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

    vim.lsp.inlay_hint.enable(true)
    vim.lsp.config("*", {
        on_attach = lsp_attach,
        capabilities = vim.version().minor < 11 and capabilities or vim.lsp.protocol.make_client_capabilities()
    })

    java_lsp.setup(capabilities, lsp_attach)
    bash_lsp.setup(capabilities, lsp_attach)

    mason_lsp.setup({
        ensure_installed = ensure_installed,
    })

    formatting.setup()
    trouble.setup()
end

return M
