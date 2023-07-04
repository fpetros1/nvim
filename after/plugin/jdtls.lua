local jdtls_ok, jdtls = pcall(require, "jdtls")
local latest_java = os.getenv('LATEST_JAVA')

if not jdtls_ok then
    vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
    return
end

if latest_java == nil then
    vim.notify "set LATEST_JAVA environment variable to use JDTLS"
    return
end

local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

local path_to_lsp_server = nil

if vim.fn.has('mac') == 1 then
    path_to_lsp_server = jdtls_path .. '/config_mac'
elseif vim.fn.has('unix') == 1 then
    path_to_lsp_server = jdtls_path .. '/config_linux'
elseif vim.fn.has('win32') == 1 then
    path_to_lsp_server = jdtls_path .. '/config_win'
end

local path_to_plugins = jdtls_path .. "/plugins/"
local path_to_jar = vim.fn.glob(path_to_plugins .. 'org.eclipse.equinox.launcher_*.jar')

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    return
end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute("mkdir " .. workspace_dir)

local java_executable = nil

if vim.fn.has('mac') == 1 then
    java_executable = 'java'
elseif vim.fn.has('unix') == 1 then
    java_executable = 'java'
elseif vim.fn.has('win32') == 1 then
    java_executable = 'java.exe'
end

local env_config = require('fpetros.env-config')

-- Main Config
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        os.getenv('LATEST_JAVA') .. '/bin/' .. java_executable,
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', path_to_jar,
        '-configuration', path_to_lsp_server,
        '-data', workspace_dir,
    },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = env_config.java_runtimes
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
                settings = {
                    url = vim.fn.stdpath('config') .. '/lsp-extra-config/jdtls/eclipse-java-google-style.xml',
                    profile = 'GoogleStyle'
                }
            },

        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org"
            },
        },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },

    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        bundles = {},
    },
}

config['on_attach'] = function(client, bufnr)
    local opts_lsp = { buffer = bufnr, remap = false }
    local opts_jdtls = { buffer = bufnr, silent = true, noremap = true }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts_lsp)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts_lsp)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts_lsp)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts_lsp)
    vim.keymap.set("n", "<leader>ww", function() vim.lsp.buf.workspace_symbol() end, opts_lsp)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts_lsp)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next() end, opts_lsp)
    vim.keymap.set("n", "<leader>Nd", function() vim.diagnostic.goto_prev() end, opts_lsp)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts_lsp)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts_lsp)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts_lsp)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts_lsp)

    vim.keymap.set("n", "<leader>oi",
        "<cmd>lua require('jdtls').organize_imports()<cr>", opts_jdtls)
end

vim.api.nvim_create_autocmd('FileType', {
    group = java_cmds,
    pattern = { 'java' },
    desc = 'Setup jdtls',
    callback = function() require('jdtls').start_or_attach(config) end,
})
