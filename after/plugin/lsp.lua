local lsp = require("lsp-zero")

lsp.preset("recommended")

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
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 5000
    },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['jdtls'] = { 'java' },
        ['tsserver'] = { 'ts', 'js', 'typescript', 'javascript' },
        ['bashls'] = { 'bash', 'sh', 'shell' },
        ['jsonls'] = { 'json' },
        ['rust_analyzer'] = { 'rust' },
        ['pylsp'] = { 'python' }
    }
})

lsp.skip_server_setup({ 'jdtls' })

lsp.setup()

--vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        highlight_whole_line = false,
        only_current_line = true
    }
})

require("lsp_lines").setup()
