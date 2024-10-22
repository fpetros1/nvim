return {
    setup_formatter = function()
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
            local tmp_name   = os.tmpname()

            local cmd        = {
                env_config.java.lsp_java_home .. '/bin/' .. java_executable,
                "-jar " .. java_format_jar,
                "-",
                "> " .. tmp_name
            }

            local full_cmd   = table.concat(cmd, " ")

            local fileHandle = assert(io.popen(full_cmd, 'w'))
            fileHandle:write(table.concat(vim.api.nvim_buf_get_lines(event.buf, 0, -1, false), "\n"))
            fileHandle:close()

            local lineTable = {}
            local lineCount = 0

            for line in io.lines(tmp_name) do
                table.insert(lineTable, line)
                lineCount = lineCount + 1
            end

            if lineCount > 0 then
                vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lineTable)
            end

            os.remove(tmp_name)
        end

        vim.keymap.set("n", "<leader>fm", format_code_using_google, opts)
        vim.keymap.set("v", "<leader>fm", format_code_using_google, opts)
        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.java' },
            desc = 'Format java file using Google Format',
            callback = format_code_using_google,
        })
    end
}
