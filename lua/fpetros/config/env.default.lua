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
                java = {
                    eclipse = {
                        downloadSources = true,
                    },
                    contentProvider = {
                        preferred = 'fernflower',
                    },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                        runtimes = {}
                    },
                    inlayHints = {
                        parameterNames = {
                            enabled = "literals"
                        }
                    },
                    format = {
                        enabled = false
                    },
                    jdt = {
                        ls = {
                            lombokSupport = {
                                enabled = true
                            }
                        }
                    },
                    maven = {
                        downloadSources = true
                    },
                    implementationsCodeLens = {
                        enabled = true
                    },
                    referencesCodeLens = {
                        enabled = true
                    }
                }
            }
        },
        ['rust_analyzer'] = {
            enabled = false,
        },
    }
}
