local has_oil, oil = pcall(require, 'oil')
local has_oil_util, oil_util = pcall(require, 'oil.util')
local has_oil_git, oil_git = pcall(require, 'oil-git-status')
local color = require('fpetros.color')

local is_open = false
local M = {}

M.can_setup = function()
    return has_oil and has_oil_util and has_oil_git
end

M.is_open = function()
    return is_open
end

M.close_if_open = function(discard_all_changes)
    if M.can_setup and M.is_open() then
        if discard_all_changes then
            oil.discard_all_changes()
        end
        oil.close({ exit_if_last_buf = true })
        is_open = false
    end
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    oil.setup({
        default_file_explorer = false,
        win_options = {
            signcolumn = 'yes:2'
        },
        columns = {
            'icon',
            'size',
        },
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = "actions.select",
            ["<C-s>"] = { "actions.select", opts = { vertical = true } },
            ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["<C-l>"] = "actions.refresh",
            ["-"] = { "actions.parent", mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["H"] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        float = {
            padding = 2,
            max_width = 0.6,
            max_height = 0,
            border = "rounded",
            win_options = {
                winblend = 0,
            },
            -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = nil,
            -- preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = "above",
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            override = function(conf)
                return conf
            end,
        },
        confirmation = {
            max_width = 0.4,
            min_width = { 40, 0.1 },
            width = nil,
            max_height = 0.4,
            min_height = { 5, 0.1 },
            height = nil,
            border = "rounded",
            win_options = {
                winblend = 0,
            },
        },
        progress = {
            max_width = 0.4,
            min_width = { 40, 0.4 },
            width = nil,
            max_height = { 10, 0.4 },
            min_height = { 5, 0.1 },
            height = nil,
            border = "rounded",
            minimized_border = "none",
            win_options = {
                winblend = 0,
            },
        },
    })

    oil_git.setup()

    local hijack_netrw = function()
        local netrw_bufname

        pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
        vim.api.nvim_create_autocmd("VimEnter", {
            pattern = "*",
            once = true,
            callback = function()
                pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
            end,
        })

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                vim.schedule(function()
                    if vim.bo[0].filetype == "netrw" then
                        return
                    end
                    local bufname = vim.api.nvim_buf_get_name(0)
                    if vim.fn.isdirectory(bufname) == 0 then
                        _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
                        return
                    end

                    -- prevents reopening of file-browser if exiting without selecting a file
                    if netrw_bufname == bufname then
                        netrw_bufname = nil
                        return
                    else
                        netrw_bufname = bufname
                    end

                    -- ensure no buffers remain with the directory name
                    --vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })

                    oil.open_float(oil.get_current_dir(), {
                        preview = {}
                    }, function()
                        is_open = true
                    end)
                end)
            end,
            desc = "oil.nvim replacement for netrw",
        })
    end

    hijack_netrw()

    vim.keymap.set("n", "<C-b>", function()
        oil.open_float(oil.get_current_dir(), {
            preview = {}
        }, function()
            is_open = true
        end)
    end, { desc = "Open oil with preview" })

    local close = function()
        oil.discard_all_changes()
        oil.close({ exit_if_last_buf = true })
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "OilEnter",
        callback = function(event)
            if oil_util.is_floating_win() then
                vim.keymap.set({ 'n', 'v', 'i', 't' }, "<C-b>", close, {
                    buffer = event.buf,
                })
                vim.keymap.set("n", "<Esc>", close, {
                    buffer = event.buf,
                })
                vim.keymap.set("n", "q", close, {
                    buffer = event.buf,
                })
            end
        end,
    })

    vim.api.nvim_create_autocmd(
        { "ExitPre" },
        {
            callback = function(event)
                oil.discard_all_changes()
            end
        }
    )

    local palette = color.palette()

    vim.api.nvim_set_hl(0, 'OilHidden', { fg = palette.gray50 or palette.gray_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilDir', { fg = palette.cyan or palette.cyan_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilDirIcon', { fg = palette.cyan or palette.cyan_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilSocket', { fg = palette.lavender, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilSocketHidden', { fg = palette.gray50 or palette.gray_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilLink', { fg = palette.lime, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilOrphanLink', { fg = palette.lime, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilLinkHidden', { fg = palette.gray50 or palette.gray_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilLinkTarget', { fg = palette.coral, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilOrphanLinkTarget', { fg = palette.coral, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilLinkTargetHidden', { fg = palette.gray50 or palette.gray_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilFile', { fg = palette.fg, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilFileHidden', { fg = palette.gray50 or palette.gray_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilCreate', { fg = palette.emerald, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilDelete', { fg = palette.red, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilMove', { fg = palette.orange, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilCopy', { fg = palette.khaki or palette.yello, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilChange', { fg = palette.orange, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilRestore', { fg = palette.slate or palette.slate_blue, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilPurge', { fg = palette.crimson or palette.purple, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilThash', { fg = palette.crimson or palette.purple, bg = palette.bg })
    vim.api.nvim_set_hl(0, 'OilTrashSourcePath', { fg = palette.crimson or palette.purple, bg = palette.bg })

    vim.api.nvim_set_hl(0, 'OilGitStatusIndexUnmodified', { fg = palette.fg })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexIgnored', { fg = palette.red })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexUntracked', { fg = palette.grey50 or palette.gray_blue })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexAdded', { fg = palette.emerald })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexCopied', { fg = palette.khaki or palette.yellow })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexDeleted', { fg = palette.red })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexModified', { fg = palette.khaki or palette.yellow })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexRenamed', { fg = palette.khaki or palette.yellow })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexTypeChanged', { fg = palette.khaki or palette.yellow })
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexUnmerged', { fg = palette.slate or palette.slate_blue })
end

return M
