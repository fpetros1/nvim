local has_eldritch, eldritch = pcall(require, 'eldritch')
local has_moonfly, moonfly = pcall(require, 'moonfly')
local has_nightfly, nightfly = pcall(require, 'nightfly')
local env = require('fpetros.config.env')

local M = {}

M.can_setup = function()
    return has_eldritch or has_moonfly or has_nightfly
end

M.palette = function()
    if has_moonfly and env.colorscheme == 'moonfly' then
        local palette = moonfly.palette

        palette['fg'] = '#bdbdbd'

        return palette
    end

    if has_nightfly and env.colorscheme == 'nightfly' then
        local palette = nightfly.palette

        palette['fg'] = '#bdc1c6'

        return palette
    end

    if has_eldritch and env.colorscheme == 'eldritch' then
        return {
            bg       = '#323449',
            fg       = '#EBFAFA',
            yellow   = '#F1FC79',
            cyan     = '#04D1F9',
            darkblue = '#081633',
            green    = '#37F499',
            orange   = '#F7C67F',
            violet   = '#A9A1E1',
            magenta  = '#A48CF2',
            blue     = '#51afef',
            red      = '#F16C75',
        }
    end

    return {}
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    if has_eldritch then
        eldritch.setup({
            transparent = vim.g.neovide == nil,
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
    end

    if has_moonfly then
        vim.g.moonflyCursorColor = true
        vim.g.moonflyTerminalColors = true
        vim.g.moonflyTransparent = true
        vim.g.moonflyNormalFloat = true
        vim.g.moonflyVirtualTextColor = true
        vim.g.moonflyWinSeparator = 2
    end

    if has_nightfly then
        vim.g.nightflyCursorColor = true
        vim.g.nightflyTerminalColors = true
        vim.g.nightflyTransparent = true
        vim.g.nightflyNormalFloat = true
        vim.g.nightflyVirtualTextColor = true
        vim.g.nightflyWinSeparator = 2
    end

    vim.cmd.colorscheme(env.colorscheme)
end

return M
