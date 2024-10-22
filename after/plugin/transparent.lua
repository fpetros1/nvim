vim.cmd("set pumblend=0")

require("transparent").setup({ -- Optional, you don't have to run setup.
    groups = {                 -- table: default groups
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer', 'BlinkCmpMenu', 'BlinkCmpDoc', 'BlinkCmpSignatureHelp', 'Noice', 'noice_lsp_docs'
    },
    extra_groups = {
        "Pmenu",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NormalFloat",
        "NeoTreeTitleBar",
        "NeoTreeFloatTitle"
    },
    exclude_groups = {
    }, -- table: groups you don't want to clear
});

require("transparent").clear_prefix("Telescope")
require("transparent").clear_prefix("Harpoon")
require("transparent").clear_prefix("Git")
require("transparent").clear_prefix("Float")
require("transparent").clear_prefix("Lua")
require("transparent").clear_prefix("WhichKey")
require("transparent").clear_prefix("Mini")
require("transparent").clear_prefix("Lazy")
require("transparent").clear_prefix("Mason")
require("transparent").clear_prefix("Noice")
