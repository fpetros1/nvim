local env = require('fpetros.config.env')
local has_transparent, _ = pcall(require, 'transparent')

local M = {}

M.can_setup = function()
    return vim.g.neovide and env.gui.neovide and has_transparent
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    vim.cmd("let g:neovide_padding_bottom=0")
    vim.cmd("let g:neovide_padding_top=0")
    vim.cmd("let g:neovide_padding_left=0")
    vim.cmd("let g:neovide_padding_right=0")

    if env.gui.neovide.transparency.enabled then
        vim.cmd("let g:neovide_opacity=" .. env.gui.neovide.transparency.value)
    end
end

return M
