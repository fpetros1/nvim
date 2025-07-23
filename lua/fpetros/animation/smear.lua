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
        stiffness = 0.5,
        trailing_stiffness = 0.5,
        damping = 0.67,
        matrix_pixel_threshold = 0.5,
        smear_to_cmd = false
    })
end

return M
