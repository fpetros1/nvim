local has_lazygit, lazygit = pcall(require, 'lazygit')

local M = {}

M.can_setup = function()
    return has_lazygit
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    vim.keymap.set('n', '<leader>ggg', function()
        vim.cmd('LazyGit')
    end, { desc = 'Open Lazygit' })
end

return M
