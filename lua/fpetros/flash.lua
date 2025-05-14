local has_flash, flash = pcall(require, 'flash')

local M = {}

M.can_setup = function()
    return has_flash
end

M.setup = function()
    if not M.can_setup() then
        return
    end

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

return M
