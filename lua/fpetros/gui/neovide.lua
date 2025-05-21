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

    vim.cmd("TransparentEnable")
    vim.cmd("let g:neovide_padding_bottom=0")
    vim.cmd("let g:neovide_padding_top=0")
    vim.cmd("let g:neovide_padding_left=0")
    vim.cmd("let g:neovide_padding_right=0")

    local neovide_config = env.gui.neovide

    if neovide_config.transparency.enabled then
        vim.cmd("let g:neovide_opacity=" .. neovide_config.transparency.value)
    end

    if neovide_config.background.enabled then
        vim.cmd("TransparentDisable")
    end
end

return M
