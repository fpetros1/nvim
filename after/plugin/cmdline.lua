local has_mini_files, mini_files = pcall(require, 'mini.files')
local has_fine_cmd_line, cmdline = pcall(require, 'fine-cmdline')

if has_fine_cmd_line then
    cmdline.setup({
        cmdline = {
            prompt = ' 󰒊 '
        }
    })

    local open_cmdline = function()
        if has_mini_files then
            mini_files.close()
        end
        cmdline.open()
    end

    vim.keymap.set('n', ':', open_cmdline, { noremap = true })
    vim.keymap.set('v', ':', open_cmdline, { noremap = true })
end
