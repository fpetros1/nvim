local has_lualine, lualine = pcall(require, 'lualine')
local color = require('fpetros.color')
local env = require('fpetros.config.env')

local M = {}

M.can_setup = function()
    return has_lualine
end

M.setup = function()
    local colors = color.palette()
    -- Custom Lualine component to show attached language server
    local clients_lsp = function()
        local bufnr = vim.api.nvim_get_current_buf()

        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            return ""
        end

        local c = {}
        for _, client in pairs(clients) do
            table.insert(c, client.name)
        end
        return " " .. table.concat(c, "|")
    end

    lualine.setup({
        options = {
            theme = env.colorscheme == 'tokyonight' and 'tokyonight' or {
                replace = {
                    a = { fg = colors.fg, bg = colors.bg, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.grey35 or colors.gray_blue },
                },
                inactive = {
                    a = { fg = colors.fg, bg = colors.grey39 or colors.gray_blue, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.grey35 or colors.gray_blue },
                    c = { fg = colors.fg, bg = colors.grey16 or colors.gray_blue },
                },
                normal = {
                    a = { fg = colors.bg, bg = colors.lavender, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.grey35 or colors.gray_blue },
                    c = { fg = colors.fg, bg = colors.grey16 or colors.gray_blue },
                },
                visual = {
                    a = { fg = colors.bg, bg = colors.orange, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.grey35 or colors.gray_blue },
                },
                insert = {
                    a = { fg = colors.bg, bg = colors.emerald, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.grey35 or colors.gray_blue },
                },
            },
            component_separators = "",
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "Outline" },
        },
        sections = {
            lualine_a = {
                { "mode", separator = { left = " ", right = "" }, icon = "" },
            },
            lualine_b = {
                {
                    "filetype",
                    icon_only = true,
                    padding = { left = 1, right = 0 },
                },
                "filename",
            },
            lualine_c = {
                {
                    "branch",
                    icon = "",
                },
                {
                    "diff",
                    symbols = { added = " ", modified = " ", removed = " " },
                    colored = false,
                },
            },
            lualine_x = {
                {
                    "diagnostics",
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    update_in_insert = true,
                },
            },
            lualine_y = { clients_lsp },
            lualine_z = {
                { "location", separator = { left = "", right = " " }, icon = "" },
            },
        },
        inactive_sections = {
            lualine_a = { "filename" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "location" },
        },
        extensions = { "toggleterm", "trouble" },
    })
end

return M
