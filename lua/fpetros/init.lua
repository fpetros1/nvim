local modules = {
    'set',
    'remap',
    'lazy',
    'mason',
    'gui',
    'notifications',
    'animation',
    'color',
    'line',
    'fzf',
    'filemanager',
    'mini',
    'harpoon',
    'treesitter',
    'noice',
    'tmux-navigation',
    'dashboard',
    'move',
    'markdown',
    'terminal',
    'lsp',
    'flash',
    'git'
}

for _, module in ipairs(modules) do
    require('fpetros.' .. module).setup()
end
