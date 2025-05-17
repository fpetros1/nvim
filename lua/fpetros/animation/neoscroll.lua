local has_neoscroll, neoscroll = pcall(require, 'neoscroll')

local M = {}

M.can_setup = function()
    return has_neoscroll
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    neoscroll.setup({})
end

return M
