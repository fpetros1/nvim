local has_lazy, lazy = pcall(require, 'lazy')

local M = {}

M.can_setup = function()
    return has_lazy
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    lazy.setup({
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        { "saghen/blink.cmp",           version = "1.*" },
        "xiyaowong/transparent.nvim",
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
        },
        { "bluz71/vim-moonfly-colors",  name = "moonfly",  lazy = false, priority = 1001 },
        { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1002 },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            "https://codeberg.org/fpetros/lsp_lines.nvim.git",
            as = "lsp_lines"
        },
        {
            "adigitoleo/haunt.nvim",
            as = "haunt"
        },
        { 'rcarriga/nvim-notify' },
        {
            'nvim-treesitter/nvim-treesitter',
            dependencies = {
                {
                    "nushell/tree-sitter-nu",
                    "nvim-treesitter/playground",
                    "nvim-treesitter/nvim-treesitter-context",
                }
            },
        },
        {
            "folke/lsp-trouble.nvim",
            dependencies = "nvim-tree/nvim-web-devicons",
        },
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {},
        },
        {
            "folke/which-key.nvim",
            config = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require("which-key").setup {}
            end
        },
        { "alexghergh/nvim-tmux-navigation" },
        { 'echasnovski/mini.ai',            version = false },
        { 'echasnovski/mini.surround',      version = false },
        { 'echasnovski/mini.indentscope',   version = false },
        {
            'fedepujol/move.nvim'
        },
        {
            'folke/noice.nvim',
            dependencies = {
                'MunifTanjim/nui.nvim',
            }
        },
        {
            'nvimdev/dashboard-nvim',
            as = "dashboard",
            event = 'VimEnter',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        "lewis6991/gitsigns.nvim",
        {
            'MeanderingProgrammer/render-markdown.nvim',
            dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
            opts = {},
        },
        {
            "karb94/neoscroll.nvim",
            as = 'neoscroll'
        },
        'stevearc/quicker.nvim',
        {
            'stevearc/oil.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', 'refractalize/oil-git-status.nvim' },
            lazy = false,
        },
        {
            'mfussenegger/nvim-jdtls',
            dependencies = {
                { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
            }
        },
        'folke/lazydev.nvim',
        'sphamba/smear-cursor.nvim',
        {
            "folke/snacks.nvim",
            lazy = false,
            opts = {
                bigfile = { enabled = true },
                picker = { enabled = true },
                lazygit = { enabled = true },
                rename = { enabled = true },
                quickfile = { enabled = true },
                words = { enabled = true },
            },
        }
    });
end

return M
