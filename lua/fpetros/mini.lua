local has_mini_ai, mini_ai                    = pcall(require, 'mini.ai')
local has_mini_surround, mini_surround        = pcall(require, 'mini.surround')
local has_mini_indentscope, mini_indent_scope = pcall(require, 'mini.indentscope')

local M                                       = {}

M.can_setup_surround                          = function()
    return has_mini_surround
end

M.can_setup_indentscope                       = function()
    return has_mini_indentscope
end

M.can_setup_ai                                = function()
    return has_mini_ai
end

M.can_setup                                   = function()
    return M.can_setup_surround() or M.can_setup_animate() or M.can_setup_indentscope() or M.can_setup_ai()
end

M.setup                                       = function()
    if M.can_setup_surround() then
        mini_surround.setup({
            mappings = {
                add = 'za',
                delete = 'zd',
                replace = 'zr'
            }
        })
    end

    if M.can_setup_indentscope() then
        mini_indent_scope.setup()
    end

    if M.can_setup_ai() then
        mini_ai.setup()
    end
end

return M
