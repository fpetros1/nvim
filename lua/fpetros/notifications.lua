local has_notify, notify = pcall(require, 'notify')

local M = {}

M.can_setup = function()
    return has_notify
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    notify.setup({
        background_colour = "#000000",
        fps = 30,
        max_width = function() return math.floor(0.25 * vim.o.columns) end,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        time_formats = {
            notification = "%T",
            notification_history = "%FT%T"
        },
        timeout = 2000,
        top_down = true
    })

    vim.notify = notify
end

return M
