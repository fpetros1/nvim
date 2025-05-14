local has_lsp_lines, lsp_lines = pcall(require, 'lsp_lines')

local M = {}

M.can_setup = function()
    return has_lsp_lines
end

M.setup = function()
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = {
            highlight_whole_line = false,
            only_current_line = true
        }
    })

    lsp_lines.setup()
end

return M
