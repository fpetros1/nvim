local M = {}

M.setup = function(capabilities)
    vim.lsp.config("bashls", {
        filetypes = { 'sh', 'zsh', 'bash' },
        capabilities = capabilities
    })

    return function(_, _) end
end

return M
