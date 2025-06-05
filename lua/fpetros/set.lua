local M = {}

M.setup = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.fillchars:append { eob = " " }

    vim.opt.guicursor =
    "n-v-c:hor50,i-ci-ve:ver50,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
    vim.o.mouse = "a"

    vim.opt.nu = true
    vim.opt.relativenumber = false

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.cmd('set cursorline')

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
end

return M
