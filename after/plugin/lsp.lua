require('mason').setup({})
local mason_lspconfig = require('mason-lspconfig')
local lsp = require("lsp-zero")
local fzf = require('fzf-lua')
local java = require('java')
local env_config = require('fpetros.env-config')

local lsp_attach = function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "<leader>ca", function() fzf.lsp_code_actions({}) end, { desc = "LSP Code Actions" })
    vim.keymap.set("n", "<leader>fr", function() fzf.lsp_references({}) end, { desc = "LSP find References" })
    vim.keymap.set("n", "gd", function() fzf.lsp_definitions({}) end, { desc = "LSP Find Definitions" })
    vim.keymap.set("n", "gi", function() fzf.lsp_implementations({}) end, { desc = "LSP Find Implementations" })
    vim.keymap.set("n", "gD", function() fzf.lsp_declarations({}) end, { desc = "LSP Declarations" })

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    if client.name == 'jdtls' then
        local java_executable = nil

        if vim.fn.has('mac') == 1 then
            java_executable = 'java'
        elseif vim.fn.has('unix') == 1 then
            java_executable = 'java'
        elseif vim.fn.has('win32') == 1 then
            java_executable = 'java.exe'
        end

        local google_java_format_config = env_config.java.google_java_format

        if (google_java_format_config ~= nil and google_java_format_config.enabled == true) then
            local format_code_using_google = function(event)
                local jar = google_java_format_config.jar

                if (jar == nil) then
                    return
                end

                local tmp_name   = os.tmpname()

                local cmd        = {
                    env_config.java.lsp_java_home .. '/bin/' .. java_executable,
                    "--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
                    "--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
                    "--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
                    "--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
                    "--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
                    "--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
                    "-jar " .. jar,
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
                group = java_cmds,
                pattern = { '*.java' },
                desc = 'Format java file using Google Format',
                callback = format_code_using_google,
            })
        end

        vim.keymap.set("n", "<leader>tt",
            "<cmd>lua require('java').test.run_current_method()<CR>", opts)
        vim.keymap.set("n", "<leader>tT",
            "<cmd>lua require('java').test.run_current_class()<CR>", opts)
        vim.keymap.set("n", "<leader>tR",
            "<cmd>lua require('java').test.view_last_report()<CR>", opts)
    end
end

java.setup({})

lsp.extend_lspconfig({
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    },
})

mason_lspconfig.setup({
    ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'bashls',
        'lua_ls',
        'jsonls',
        'pylsp',
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        jdtls = function()
            require('lspconfig').jdtls.setup({
                settings = {
                    java = {
                        configuration = {
                            runtimes = env_config.java.runtimes
                        }
                    }
                }
            })
        end
    }
})

lsp.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 5000
    },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['tsserver'] = { 'ts', 'js', 'typescript', 'javascript' },
        ['bashls'] = { 'bash', 'sh', 'shell' },
        ['jsonls'] = { 'json' },
        ['rust_analyzer'] = { 'rust' },
        ['pylsp'] = { 'python' },
        ['gopls'] = { 'go' },
        ['google-java-format'] = { 'java' }
    }
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
        highlight_whole_line = false,
        only_current_line = true
    }
})

require("lsp_lines").setup()
