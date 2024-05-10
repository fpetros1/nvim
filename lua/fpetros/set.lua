local env_config = require('fpetros.env-config')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fillchars:append { eob = " " }

vim.opt.guifont = env_config.gui.font
vim.opt.linespace = env_config.gui.linespace

vim.opt.guicursor = ""
vim.o.mouse = "a"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.o.errorbells = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 100
vim.opt.autoread = true

vim.opt.colorcolumn = "0"

vim.filetype.add {
    pattern = {
        ['.*/hypr/.*%.conf'] = 'hyprlang',
    },
}
