return {
    colorscheme = 'moonfly',
    gui = {
        font = '', -- Example: undefined:style=Regular:h15
        neovide = {
            transparency = {
                enabled = true,
                value = 0.8
            },
            background = {
                enabled = true
            }
        }
    },
    lsp = {
        ['lua_ls'] = {
            enabled = false,
        },
        ['bashls'] = {
            enabled = false,
        },
        ['jsonls'] = {
            enabled = false,
        },
        ['ts_ls'] = {
            enabled = false,
        },
        ['pylsp'] = {
            enabled = false
        },
        ['yamlls'] = {
            enabled = false
        },
        ['jdtls'] = {
            enabled = false,
            settings = {
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    updateBuildConfiguration = 'interactive',
                    runtimes = {}
                }
            }
        },
        ['rust_analyzer'] = {
            enabled = false,
        },
    }
}
