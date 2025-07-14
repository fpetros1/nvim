local has_treesitter_config, treesitter_config = pcall(require, 'nvim-treesitter.configs')

local M = {}

M.can_setup = function()
    return has_treesitter_config
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    treesitter_config.setup({
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "java",
            "python",
            "rust",
            "bash",
            "html",
            "typescript",
            "javascript",
            "angular" },
    })

    vim.cmd('TSEnable highlight')
    vim.cmd('TSEnable indent')
end

return M
