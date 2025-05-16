local has_specs, specs = pcall(require, 'specs')
local has_neoscroll, neoscroll = pcall(require, 'neoscroll')

local M = {}

M.can_setup = function()
    return has_specs and has_neoscroll
end

M.setup = function()
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
    neoscroll.setup({})

    vim.api.nvim_set_hl(0, 'SpecsBg', { fg = '#ebfafa', bg = '#f265b5' })
end

return M
