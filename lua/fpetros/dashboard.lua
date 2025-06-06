local has_dashboard, dashboard = pcall(require, 'dashboard')

local M = {}

M.can_setup = function()
    return has_dashboard
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    local browser_cmd = nil

    if vim.fn.has('mac') == 1 then
        browser_cmd = 'open'
    elseif vim.fn.has('unix') == 1 then
        browser_cmd = 'xdg-open'
    elseif vim.fn.has('win32') == 1 then
        browser_cmd = 'start'
    end

    local open_github = browser_cmd .. ' https://github.com/fpetros1'

    local action = function(path)
        vim.cmd('e ' .. path)
    end

    dashboard.setup {
        config = {
            shortcut = {
                { key = '1', desc = '[  fpetros]', group = 'DashboardShortCut', action = 'os.execute("' .. open_github .. '")' },
            },
            week_header = {
                enable = true
            },
            project = { enable = true, action = action },
            footer = {
                "",
                "",
                " Java" .. "  Javascript" .. " 󰛦 Typescript" .. "  Python" .. " 󱆃 Bash"
            }
        }
    }

    vim.keymap.set('n', '<leader>dg', '<cmd>Dashboard<cr>')
end

return M
