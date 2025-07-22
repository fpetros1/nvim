local has_snacks, snacks = pcall(require, 'snacks')
local filemanager        = require('fpetros.filemanager')

local M                  = {}

M.can_setup              = function()
    return has_snacks
end

M.setup                  = function()
    vim.keymap.set({ "n", "v" }, "<leader><leader>", function()
        filemanager.close_if_open(true)
        snacks.picker.files()
    end)

    vim.keymap.set({ "n", "v" }, "<leader>/", function()
        filemanager.close_if_open(true)
        snacks.picker.grep()
    end)
end

return M
