local M = {}

M.setup = function(capabilities, lsp_attach)
    vim.lsp.config("bashls", {
        on_attach = lsp_attach,
        filetypes = { 'sh', 'zsh', 'bash' },
        capabilities = capabilities
    })
end

return M
