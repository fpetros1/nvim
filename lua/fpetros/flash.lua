local has_flash, flash = pcall(require, 'flash')

if has_flash then
    flash.setup({})

    local flash_func = function()
        flash.jump({
            modes = {
                search = {
                    enabled = true
                }
            }
        })
    end

    vim.keymap.set('n', 'f', flash_func)
    vim.keymap.set('v', 'f', flash_func)
    vim.keymap.set('n', '<C-f>', flash_func, { desc = "Flash" })
end
