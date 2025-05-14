local servers = {}

local default_format_function = function()
    vim.lsp.buf.format()
end

local blacklist = {
    'yamlls'
}

local formatting_group = vim.api.nvim_create_augroup('FormattingGroup', {})

return {
    set_server = function(server_list, format_func)
        for _, server in ipairs(server_list) do
            if not vim.tbl_contains(blacklist, server) then
                servers[server] = format_func or default_format_function
            end
        end
    end,
    setup = function()
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = formatting_group,
            desc = 'Format enabled LSP files',
            callback = function(event)
                local clients = vim.lsp.get_clients({ bufnr = event.buf })

                for _, client in ipairs(clients) do
                    local lsp_config = client.config

                    if servers[lsp_config.name] ~= nil and vim.tbl_contains(lsp_config.filetypes, vim.o.filetype) then
                        servers[lsp_config.name](event)
                    end
                end
            end
        })
    end
}
