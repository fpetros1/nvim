local has_mini_files, mini_files = pcall(require, 'mini.files')

if has_mini_files then
    mini_files.setup({
        mappings = {
            mark_set = '',
            mark_goto = ''
        }
    })

    vim.keymap.set('n', '<C-b>', function()
        if not mini_files.close() then mini_files.open() end
    end)
end
