local has_smear, smear = pcall(require, 'smear_cursor')

local M = {}

M.can_setup = function()
    return has_smear
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    smear.setup({
        cursor_color = "#b2ceee",
        normal_bg = "#011627",
        legacy_computing_symbols_support = true,
    })
end

return M
