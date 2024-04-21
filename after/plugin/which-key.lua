local config = {
    window = {
        border = "rounded"
    }
}

if vim.g.neovide then
    config.window.winblend = 100
    config.window.margin = { 0, 0.5, 0, 0 }
end

require("which-key").setup(config)
