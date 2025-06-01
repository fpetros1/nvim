local M = {}

M.get_nearest_node = function(nodes, opts)
    local current_node = vim.treesitter.get_node({ bufnr = opts.bufnr })

    if not current_node then return nil end

    local expr = current_node

    while expr do
        if vim.list_contains(nodes, expr:type()) then
            return expr
        end
        expr = expr:parent()
    end
end

M.get_node_text = function(node, opts)
    return vim.treesitter.get_node_text(node, opts.bufnr)
end

return M
