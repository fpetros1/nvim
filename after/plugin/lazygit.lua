local has_minifiles, minifiles = pcall(require, 'mini.files')

vim.keymap.set('n', '<leader>ggg', function()
    if has_minifiles then
        minifiles.close()
    end
    vim.cmd('LazyGit')
end, { desc = 'Open Lazygit' })
