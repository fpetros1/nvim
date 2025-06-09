local has_lazydev, lazydev = pcall(require, 'lazydev')

local M = {}

M.can_setup = function()
    return has_lazydev
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    lazydev.setup({
        library = { 'nvim-dap-ui' }
    })
end

return M
