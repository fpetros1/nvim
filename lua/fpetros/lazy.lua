require("lazy").setup({
    --{ 'nvim-telescope/telescope.nvim', dependencies = { { 'nvim-lua/plenary.nvim' } } },
    'nvim-telescope/telescope-ui-select.nvim',
    { "akinsho/toggleterm.nvim" },
    "onsails/lspkind.nvim",
    "lewis6991/gitsigns.nvim",
    {
        'fedepujol/move.nvim'
    },
    { 'echasnovski/mini.files',         version = false },
    { 'echasnovski/mini.animate',       version = false },
    { 'echasnovski/mini.surround',      version = false },
    { 'echasnovski/mini.indentscope',   version = false },
    { "alexghergh/nvim-tmux-navigation" },
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify'
        }
    },
    {
        "folke/twilight.nvim",
        opts = {}
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    },
    { 'echasnovski/mini.ai',        version = false },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        'nvimdev/dashboard-nvim',
        as = "dashboard",
        event = 'VimEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    'rebelot/kanagawa.nvim',
    { 'NTBBloodbath/doom-one.nvim', as = "doom-one" },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    { "catppuccin/nvim",     as = "catppuccin" },
    'nvim-java/nvim-java',
    'xiyaowong/transparent.nvim',
    {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    },
    "nvim-treesitter/playground",
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    "theprimeagen/refactoring.nvim",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "nvim-treesitter/nvim-treesitter-context",
    {
        "folke/lsp-trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'onsails/lspkind.nvim' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'windwp/nvim-autopairs' },
        }
    },
    -- {
    --     'saghen/blink.cmp',
    --     lazy = false,
    --     version = 'v0.2.1',
    --     opts = {
    --         highlight = {
    --             use_nvim_cmp_as_default = false,
    --         },
    --         nerd_font_variant = 'normal',
    --         accept = { auto_brackets = { enabled = false } },
    --         trigger = { signature_help = { enabled = false } }
    --     }
    -- },
    { 'rcarriga/nvim-notify' },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        as = "lsp_lines"
    }
})
