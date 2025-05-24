local has_neoscroll, neoscroll = pcall(require, 'neoscroll')

local M = {}

M.can_setup = function()
    return has_neoscroll and not vim.g.neovide
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    neoscroll.setup({
        hide_cursor = false,
        duration_multiplier = 0.01
    })
end

return M
