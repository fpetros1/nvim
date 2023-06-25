require("catppuccin").setup({
    background = {
        light = "latte",
        dark = "mocha"
    },
    transparent_background = false,
    integrations = {
        cmp = true,
        nvimtree = true,
        telescope = true
    }
})

vim.cmd.colorscheme "catppuccin"
