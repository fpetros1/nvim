return {
    setup_formatter = function(context)
        local env_config = require('fpetros.env-config')
        local java_format_jar = vim.fn.stdpath('data') .. '/google-java-format/google-java-format.jar'
        local java_executable = nil

        if vim.fn.has('mac') == 1 then
            java_executable = 'java'
            os.execute('check-and-download-gjf-nvim')
        elseif vim.fn.has('unix') == 1 then
            java_executable = 'java'
            os.execute('check-and-download-gjf-nvim')
        elseif vim.fn.has('win32') == 1 then
            java_executable = 'java.exe'
        end

        local format_code_using_google = function(event)
            local bufnr = 0

            if event ~= nil and event.buf ~= nil then
                bufnr = event.buf
            end

            local stdin    = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")

            local cmd      = {
                ('echo \'$stdin\' | '):gsub("$stdin", stdin),
                env_config.java.lsp_java_home .. '/bin/' .. java_executable,
                "-jar " .. java_format_jar,
                "-"
            }
            local full_cmd = table.concat(cmd, " ")
            local prog     = io.popen(full_cmd, "r")

            if not prog then
                vim.notify("Failed to open pipe")
                return
            end

            local lines = {}
            local lineCount = 0

            while true do
                local line = prog:read('*l')
                if not line then break end
                table.insert(lines, line)
                lineCount = lineCount + 1
            end

            prog:close()

            if lineCount == 0 then
                vim.notify("Failed to format using google java format")
                return
            end

            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
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
