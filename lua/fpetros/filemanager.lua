local has_neotree, neotree = pcall(require, 'neo-tree')

local M = {}

M.can_setup = function()
    return has_neotree
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    neotree.setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        filesystem = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true,
            },
        },
        window = {
            position = 'float'
        }
    })

    local function toggle_neotree()
        vim.cmd('Neotree toggle=true position=float reveal=true')
    end

    vim.keymap.set('n', '<C-b>', toggle_neotree)
    vim.keymap.set('v', '<C-b>', toggle_neotree)
    vim.keymap.set('i', '<C-b>', toggle_neotree)
end

return M
