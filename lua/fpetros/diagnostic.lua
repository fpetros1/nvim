local has_lsp_lines, lsp_lines = pcall(require, 'lsp_lines')

return {
    setup = function()
        if has_lsp_lines then
            vim.diagnostic.config({
                virtual_text = false,
                virtual_lines = {
                    highlight_whole_line = false,
                    only_current_line = true
                }
            })

            require("lsp_lines").setup()
        end
    end
}
