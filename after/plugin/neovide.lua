vim.cmd("TransparentEnable")

local env_config = require('fpetros.env-config')

if not vim.g.neovide then
    return
end

vim.cmd("let g:neovide_padding_bottom=15")
vim.cmd("let g:neovide_padding_top=15")
vim.cmd("let g:neovide_padding_left=15")
vim.cmd("let g:neovide_padding_right=15")

if not env_config.neovide then
    return
end

local neovide_config = env_config.neovide

if neovide_config ~= nil and neovide_config.transparency.enabled then
    vim.cmd("let g:neovide_transparency=" .. neovide_config.transparency.value)
end

if neovide_config ~= nil and neovide_config.background.enabled then
    vim.cmd("TransparentDisable")
end
