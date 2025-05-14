local has_transparent, transparent = pcall(require, 'transparent')
local has_eldritch, eldritch = pcall(require, 'eldritch')

local M = {}

M.can_setup = function()
    return has_transparent and has_eldritch
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    vim.cmd("set pumblend=0")

    transparent.setup({
        extra_groups = {
            "Pmenu",
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NormalFloat",
            "NeoTreeTitleBar",
            "NeoTreeFloatTitle",
            'BlinkCmpMenu',
            'BlinkCmpDoc',
            'BlinkCmpSignatureHelp',
            'Noice',
            'noice_lsp_docs',
            'QuickFixLine'
        },
        exclude_groups = {
        },
    });

    transparent.clear_prefix("Telescope")
    transparent.clear_prefix("Harpoon")
    transparent.clear_prefix("Git")
    transparent.clear_prefix("Float")
    transparent.clear_prefix("Lua")
    transparent.clear_prefix("WhichKey")
    transparent.clear_prefix("Mini")
    transparent.clear_prefix("Lazy")
    transparent.clear_prefix("Mason")
    transparent.clear_prefix("Noice")

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('transparent', { clear = true }),
        pattern = 'qf',
        callback = function()
            vim.api.nvim_set_option_value('winhl', 'Normal:dark', { win = 0 })
        end,
    })

    eldritch.setup({
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
        },
        sidebars = { "qf", "help" },
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = true,
        on_colors = function() end,
        on_highlights = function() end,
    });

    vim.cmd("colorscheme eldritch")
end

return M
