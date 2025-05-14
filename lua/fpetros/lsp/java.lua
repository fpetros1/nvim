local formatting = require('fpetros.formatting')
local mason_utils = require('fpetros.utils.mason')
local env = require('fpetros.config.env')

return {
    setup = function(capabilities, lsp_attach)
        mason_utils.ensure_installed({
            'google-java-format',
            'lombok'
        })

        local format_code_using_google = function(event)
            local bufnr = 0

            if event ~= nil and event.buf ~= nil then
                bufnr = event.buf
            end

            local cmd         = {
                vim.fn.stdpath("data") .. "/mason/packages/google-java-format/google-java-format",
                "-"
            }

            local done_format = function(obj)
                vim.schedule(function()
                    if obj.code == 0 then
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
                            vim.split(obj.stdout, '\n', { plain = true, trimempty = true }))
                        vim.cmd('noautocmd write')
                        return
                    end
                    vim.notify(obj.stderr)
                end)
            end

            local obj         = vim.system(cmd,
                    { text = true, stdin = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) })
                :wait()

            done_format(obj)
        end

        local java_config = {
            settings = env.lsp.java
        }

        local java_cmd = vim.lsp.config.jdtls.cmd
        local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/lombok/lombok.jar"

        table.insert(java_cmd,
            '--jvm-arg=-javaagent:' .. lombok_path)

        vim.lsp.config('jdtls', {
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)

                local opts = { buffer = bufnr, remap = true }

                vim.keymap.set("n", "<leader>ff", format_code_using_google, opts)
                vim.keymap.set("v", "<leader>ff", format_code_using_google, opts)

                formatting.set_server({ 'jdtls' }, format_code_using_google)

                client:notify('workspace/didChangeConfiguration', java_config)
            end,
            capabilities = capabilities,
            cmd = java_cmd,
        })

        return {
            'jdtls'
        }
    end
}
