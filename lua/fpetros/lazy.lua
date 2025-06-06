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
            "eldritch-theme/eldritch.nvim",
            lazy = false,
            priority = 1000,
        },
        { "bluz71/vim-moonfly-colors",  name = "moonfly",  lazy = false, priority = 1001 },
        { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1002 },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            "ibhagwan/fzf-lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {}
        },
        {
            "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            as = "lsp_lines"
        },
        {
            "https://git.sr.ht/~adigitoleo/haunt.nvim",
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
        {
            "kdheepak/lazygit.nvim",
            as = 'lazygit',
            lazy = true,
            cmd = {
                "LazyGit",
                "LazyGitConfig",
                "LazyGitCurrentFile",
                "LazyGitFilter",
                "LazyGitFilterCurrentFile",
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
            }
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
                'mfussenegger/nvim-dap'
            }
        }
    });
end

return M
