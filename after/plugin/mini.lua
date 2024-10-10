local has_mini_ai, mini_ai = pcall(require, 'mini.ai')
local has_mini_files, mini_files = pcall(require, 'mini.files')
local has_mini_surround, mini_surround = pcall(require, 'mini.surround')

if has_mini_ai then
    mini_ai.setup()
end

if has_mini_files then
    mini_files.setup({
        mappings = {
            mark_set = '',
            mark_goto = ''
        },
    })

    vim.keymap.set('n', '<C-b>', function()
        if not mini_files.close() then mini_files.open() end
    end)
end

if has_mini_surround then
    mini_surround.setup({
        mappings = {
            add = 'za',
            delete = 'zd',
            replace = 'zr'
        }
    })
end
