local env = require('fpetros.config.env')
local has_transparent, transparent = pcall(require, 'transparent')

local M = {}

M.can_setup = function()
    return has_transparent
end

M.setup = function()
    transparent.setup({
        extra_groups = {
            "Pmenu",
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NormalFloat",
            "NeoTreeTitleBar",
            "NeoTreeFloatTitle",
            'Noice',
            'noice_lsp_docs',
        },
        exclude_groups = {
        },
    });

    local cmd = (vim.g.neovide and env.gui.neovide.background.enabled) and "TransparentDisable" or "TransparentEnable"

    vim.cmd(cmd)

    vim.cmd("set pumblend=0")

    transparent.clear_prefix("Telescope")
    transparent.clear_prefix("Harpoon")
    transparent.clear_prefix("Git")
    transparent.clear_prefix("Float")
    transparent.clear_prefix("WhichKey")
    transparent.clear_prefix("Mini")
    transparent.clear_prefix("Lazy")
    transparent.clear_prefix("Mason")
    transparent.clear_prefix("Noice")
    transparent.clear_prefix("QuickFix")
    transparent.clear_prefix("Oil")
end

return M
