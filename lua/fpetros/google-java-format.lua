return {
    setup_formatter = function(context)
        local env_config = require('fpetros.env-config')
        local java_executable = nil

        if vim.fn.has('mac') == 1 then
            java_executable = 'java'
            os.execute('google-java-format -c')
        elseif vim.fn.has('unix') == 1 then
            java_executable = 'java'
            os.execute('google-java-format -c')
        elseif vim.fn.has('win32') == 1 then
            vim.notify('Google java Format - Windows not supported')
            return
        end

        local format_code_using_google = function(event)
            local bufnr = 0

            if event ~= nil and event.buf ~= nil then
                bufnr = event.buf
            end

            local stdin       = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')

            local cmd         = {
                'google-java-format',
                '-j',
                env_config.java.lsp_java_home .. '/bin/' .. java_executable,
            }

            local done_format = function(obj)
                vim.schedule(function()
                    if obj.code == 0 then
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(obj.stdout, '\n'))
                        return
                    end
                    vim.notify(obj.stderr)
                end)
            end

            vim.system(cmd, { text = true, stdin = stdin }, done_format)
        end

        local opts = { buffer = context.buf, remap = true }

        vim.keymap.set("n", "<leader>ff", format_code_using_google, opts)
        vim.keymap.set("v", "<leader>ff", format_code_using_google, opts)

        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.java' },
            desc = 'Format java file using Google Format',
            callback = format_code_using_google,
        })
    end
}
