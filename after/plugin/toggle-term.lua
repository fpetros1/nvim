local has_toggle_term, toggle_term = pcall(require, 'toggleterm')
local has_mini_files, mini_files   = pcall(require, 'mini.files')

if has_toggle_term then
    toggle_term.setup({})

    function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

    local opts = {
        desc = "Toggle Terminal"
    }
    local toggle_term_keybind = '<leader>;'

    local exec_toggle_term = function()
        if has_mini_files then
            mini_files.close()
        end
        vim.cmd('ToggleTerm<CR>')
    end

    vim.keymap.set('n', toggle_term_keybind, exec_toggle_term, opts)
    vim.keymap.set('v', toggle_term_keybind, exec_toggle_term, opts)
end
