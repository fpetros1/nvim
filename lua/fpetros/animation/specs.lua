local has_specs, specs = pcall(require, 'specs')

local M = {}


M.can_setup = function()
    return has_specs
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    specs.setup({
        min_jump = 10,
        popup = {
            inc_ms = 5,
            blend = 50,
            width = 30,
            winhl = 'SpecsBg',
            fader = specs.exp_fader,
            resizer = specs.slide_resizer
        }
    })

    vim.api.nvim_set_hl(0, 'SpecsBg', { fg = '#ebfafa', bg = '#f265b5' })
end

return M
