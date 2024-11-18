local has_flash, flash = pcall(require, 'flash')

if has_flash then
    flash.setup({})

    vim.keymap.set('n', 'f', "")
    vim.keymap.set('v', 'f', "")
    vim.keymap.set('n', '<C-f>', function()
        flash.jump({
            modes = {
                search = {
                    enabled = true
                }
            }
        })
    end, { desc = "Flash" })
end
