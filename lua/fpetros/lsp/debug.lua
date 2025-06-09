local has_dap, dap = pcall(require, 'dap')
local has_dap_ui, dap_ui = pcall(require, 'dapui')

local M = {}

M.can_setup = function()
    return has_dap
end

M.setup = function(attach_event)
    if not M.can_setup() then
        return
    end

    local opts = { buffer = attach_event.buf, remap = true }

    vim.keymap.set({ "n", "v" }, "<F5>", dap.continue, vim.tbl_extend('force', opts, { desc = 'Debug - Continue' }))
    vim.keymap.set({ "n", "v" }, "<F10>", dap.step_over,
        vim.tbl_extend('force', opts, { desc = 'Debug - Step Over' }))
    vim.keymap.set({ "n", "v" }, "<F11>", dap.step_into,
        vim.tbl_extend('force', opts, { desc = 'Debug - Step Into' }))
    vim.keymap.set({ "n", "v" }, "<F12>", dap.step_out, vim.tbl_extend('force', opts, { desc = 'Debug - Step Out' }))
    vim.keymap.set({ "n", "v" }, "<leader>dbb", dap.toggle_breakpoint,
        vim.tbl_extend('force', opts, { desc = 'Debug - Toggle Breakpoint' }))

    if not has_dap_ui then
        vim.keymap.set({ "n", "v" }, "<leader>dbt", dap.repl.toggle,
            vim.tbl_extend('force', opts, { desc = 'Debug - Toggle UI' }))
        vim.keymap.set({ 'n', 'v' }, '<Leader>dbp', function()
            require('dap.ui.widgets').preview()
        end, vim.tbl_extend('force', opts, { desc = 'Open Debug Preview' }))

        vim.keymap.set('n', '<Leader>dbf', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end, vim.tbl_extend('force', opts, { desc = 'Open Debug Float' }))

        vim.keymap.set('n', '<Leader>dbs', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end, vim.tbl_extend('force', opts, { desc = 'Open Debug Centered Float' }))
    end

    if has_dap_ui then
        dap_ui.setup()

        vim.keymap.set({ "n", "v" }, "<leader>dbt", dap_ui.toggle,
            vim.tbl_extend('force', opts, { desc = 'Debug - Toggle UI' }))

        dap.listeners.before.attach.dapui_config = function()
            dap_ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dap_ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dap_ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dap_ui.close()
        end
    end
end

return M
