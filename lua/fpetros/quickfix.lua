local has_quicker, quicker = pcall(require, 'quicker')

local M = {}

M.setup = function()
    if has_quicker then
        quicker.setup()

        vim.keymap.set({ 'n', 'v' }, '<leader>q', function()
            quicker.toggle()
        end)
    end
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        desc = 'dd removes item from quickfix list',
        callback = function(event)
            vim.keymap.set('n', 'dd', function()
                local curqfidx = vim.fn.line('.')
                local qfall = vim.fn.getqflist()

                if #qfall == 0 then return end

                table.remove(qfall, curqfidx)
                vim.fn.setqflist(qfall, 'r')
            end, { noremap = true, buffer = event.buf })

            vim.api.nvim_set_option_value('winhl', 'Normal:Normal', {})
        end
    })
end

return M
