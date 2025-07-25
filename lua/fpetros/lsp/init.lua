local has_lspconfig, _ = pcall(require, 'lspconfig')
local has_mason, _ = pcall(require, 'mason')
local has_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
local has_snacks, snacks = pcall(require, 'snacks')
local lazydev = require('fpetros.lsp.lazydev')
local diagnostic = require('fpetros.lsp.diagnostic')
local completion = require('fpetros.lsp.completion')
local java_lsp = require('fpetros.lsp.java')
local bash_lsp = require('fpetros.lsp.bash')
local formatting = require('fpetros.lsp.formatting')
local debugging = require('fpetros.lsp.debug')
local trouble = require('fpetros.lsp.trouble')
local env = require('fpetros.config.env')
local color = require('fpetros.color')

local M = {}

M.can_setup = function()
    return has_lspconfig and has_mason and has_mason_lsp and has_snacks and diagnostic.can_setup() and
        completion.can_setup() and trouble.can_setup() and env and env.lsp
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    lazydev.setup()

    local ensure_installed = {}
    local skip_formatting = {
        'jdtls'
    }

    for server, config in pairs(env.lsp) do
        if config.enabled then
            table.insert(ensure_installed, server)
        end
    end

    local lsp_on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "LSP Code Actions" })
        vim.keymap.set("n", "<leader>fr", function() snacks.picker.lsp_references() end, { desc = "LSP find References" })
        vim.keymap.set("n", "gd", function() snacks.picker.lsp_definitions() end, { desc = "LSP Find Definitions" })
        vim.keymap.set("n", "gi", function() snacks.picker.lsp_implementations() end,
            { desc = "LSP Find Implementations" })
        vim.keymap.set("n", "gD", function() snacks.picker.lsp_declarations() end, { desc = "LSP Declarations" })

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

        vim.keymap.set({ "n", "v" }, "<leader>ff", function() vim.lsp.buf.format() end, opts)

        if not vim.tbl_contains(skip_formatting, client.name) then
            formatting.set_server({ client.name }, nil)
        end

        local palette = color.palette()
        vim.api.nvim_set_hl(0, "LspInlayHint", { fg = palette.slate or palette.grey_blue, bg = default })
        vim.api.nvim_set_hl(0, 'MatchParen', { fg = palette.orange, bg = default, underline = true, bold = true })
    end

    diagnostic.setup()

    local completion_capabilities = completion.setup()
    local capabilities = vim.version().minor < 11 and completion_capabilities or
        vim.lsp.protocol.make_client_capabilities()

    vim.lsp.inlay_hint.enable(true)

    vim.lsp.config("*", {
        capabilities = capabilities
    })

    local java_on_attach = java_lsp.setup(capabilities)
    local bash_on_attach = bash_lsp.setup(capabilities)

    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*",
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            if client then
                lsp_on_attach(client, event.buf)
                debugging.setup(event)

                if client.name == 'jdtls' then
                    java_on_attach(event)
                    return
                end

                if client.name == 'bashls' then
                    bash_on_attach(client, event.buf)
                    return
                end
            end
        end,
    })

    mason_lsp.setup({
        ensure_installed = ensure_installed,
        automatic_enable = {
            exclude = {
                "jdtls",
            }
        }
    })

    formatting.setup()
    trouble.setup()
end

return M
