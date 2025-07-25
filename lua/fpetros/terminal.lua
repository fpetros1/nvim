local has_haunt, haunt = pcall(require, 'haunt')

local M = {}

M.can_setup = function()
    return has_haunt
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    haunt.setup({
        window = {
            winblend = 0
        }
    })

    vim.keymap.set({ 'n', 'v', 'i' }, '<C-P>', '<cmd>HauntTerm<CR>')

    vim.api.nvim_create_autocmd(
        { "TermOpen" },
        {
            callback = function(event)
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = event.buf })
                vim.keymap.set({ 'n', 't', 'v' }, '<C-P>', [[<C-\><C-n>:q<CR>]], { buffer = event.buf })
            end
        }
    )

    vim.api.nvim_create_user_command('HH', function(args)
        haunt.help(args)
    end, {
        nargs = "?",
        complete = "help",
        desc = "Open neovim help of argument or word under cursor in floating window"
    })

    vim.api.nvim_create_autocmd(
        { "ExitPre" },
        {
            callback = function(_)
                haunt.reset()
            end
        }
    )
end

return M
