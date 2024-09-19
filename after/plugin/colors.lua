-- Default options:

vim.opt.fillchars:append({
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┨',
    vertright = '┣',
    verthoriz = '╋',
})

require('kanagawa').setup({
    compile = false,  -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,   -- do not set background color;;
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = { ui = { bg_gutter = "none" } } },
    },
    overrides = function(colors) -- add/modify highlights
        return {
            WinSeparator = { fg = colors.palette.dragonBlue }
        }
    end,
    theme = "wave",    -- Load "wave" theme when 'background' option is not set
    background = {     -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus"
    },
})

vim.g.doom_one_cursor_coloring = true
vim.g.doom_one_terminal_colors = true
vim.g.doom_one_italic_comments = true
vim.g.doom_one_enable_treesitter = true
vim.g.doom_one_diagnostics_text_color = false
vim.g.doom_one_transparent_background = false

vim.g.doom_one_pumblend_enable = false
vim.g.doom_one_pumblend_transparency = 20

vim.g.doom_one_plugin_neorg = false
vim.g.doom_one_plugin_barbar = false
vim.g.doom_one_plugin_telescope = false
vim.g.doom_one_plugin_neogit = false
vim.g.doom_one_plugin_nvim_tree = true
vim.g.doom_one_plugin_dashboard = true
vim.g.doom_one_plugin_startify = false
vim.g.doom_one_plugin_whichkey = false
vim.g.doom_one_plugin_indent_blankline = false
vim.g.doom_one_plugin_vim_illuminate = false
vim.g.doom_one_plugin_lspsaga = false

vim.cmd("colorscheme doom-one")
--vim.cmd("colorscheme kanagawa")
