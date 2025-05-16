local has_nvim_tmux_nav, nvim_tmux_nav = pcall(require, 'nvim-tmux-navigation')

local M = {}

M.can_setup = function()
    return has_nvim_tmux_nav
end

M.setup = function()
    nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
    }

    local opts = { remap = true }

    vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft, opts)
    vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown, opts)
    vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp, opts)
    vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight, opts)

    vim.keymap.set('n', '<leader>wh', nvim_tmux_nav.NvimTmuxNavigateLeft, opts)
    vim.keymap.set('n', '<leader>wj', nvim_tmux_nav.NvimTmuxNavigateDown, opts)
    vim.keymap.set('n', '<leader>wk', nvim_tmux_nav.NvimTmuxNavigateUp, opts)
    vim.keymap.set('n', '<leader>wl', nvim_tmux_nav.NvimTmuxNavigateRight, opts)
end

return M
