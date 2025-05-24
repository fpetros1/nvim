local modules = {
    'set',
    'remap',
    'lazy',
    'mason',
    'color',
    'notifications',
    'animation',
    'gui',
    'line',
    'filemanager',
    'mini',
    'harpoon',
    'treesitter',
    'noice',
    'tmux-navigation',
    'dashboard',
    'markdown',
    'terminal',
    'lsp',
    'flash',
    'git',
    'fzf',
    'quickfix',
    'move',
}

for _, module in ipairs(modules) do
    require('fpetros.' .. module).setup()
end
