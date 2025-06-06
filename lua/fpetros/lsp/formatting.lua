local servers = {}

local default_format_function = function()
    vim.lsp.buf.format()
end

local blacklist = {
    'yamlls'
}

local formatting_group = vim.api.nvim_create_augroup('FormattingGroup', {})

local M = {}

M.set_server = function(server_list, format_func)
    for _, server in ipairs(server_list) do
        if not vim.tbl_contains(blacklist, server) then
            servers[server] = format_func or default_format_function
        end
    end
end

M.setup = function()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = formatting_group,
        desc = 'Activate Formatting for LSP',
        callback = function(attach_event)
            local client = vim.lsp.get_client_by_id(attach_event.data.client_id)

            vim.api.nvim_create_autocmd('BufWritePre', {
                group = formatting_group,
                desc = 'Format enabled LSP files',
                buffer = attach_event.buf,
                callback = function(event)
                    if client and servers[client.config.name] then
                        servers[client.config.name](event)
                    end
                end
            })
        end
    })
end

return M
