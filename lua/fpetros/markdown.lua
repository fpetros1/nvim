local has_render_markdown, render_markdown = pcall(require, 'render-markdown')

local M = {}

M.can_setup = function()
    return has_render_markdown
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    render_markdown.setup({})
end

return M
