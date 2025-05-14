local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local config_base_path = vim.fn.stdpath("config") .. "/lua/fpetros/config/"
local config_default_file = config_base_path .. "env.default.lua"
local config_file = config_base_path .. "env.lua"

if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end

vim.opt.rtp:prepend(lazy_path)

if not (vim.uv or vim.loop).fs_stat(config_file) then
    local default_file_handle = assert(io.open(config_default_file, 'r'))
    local example_config = default_file_handle:read('*all')
    default_file_handle:close()

    local config_file_handle = assert(io.open(config_file, 'w'))

    config_file_handle:write(example_config)
    config_file_handle:flush()
    config_file_handle:close()
end

require("fpetros")
