return function(event)
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
            vim.notify(obj.stderr, vim.log.levels.ERROR)
        end)
    end

    local obj         = vim.system(cmd,
            { text = true, stdin = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) })
        :wait()

    done_format(obj)
end
