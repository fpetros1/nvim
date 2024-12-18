vim.cmd("set pumblend=0")

require("transparent").setup({ -- Optional, you don't have to run setup.
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

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('transparent', { clear = true }),
    pattern = 'qf',
    callback = function()
        vim.api.nvim_win_set_option(0, 'winhl', 'Normal:dark')
    end,
})
