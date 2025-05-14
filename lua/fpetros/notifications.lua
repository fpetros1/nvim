local has_notify, notify = pcall(require, 'notify')
local has_fzf, fzf = pcall(require, 'fzf-lua')

if has_notify then
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

    local serializeNotification = function (notification)
       local serialized = {}

       table.insert(serialized, table.concat(notification.title, ''))
       table.insert(serialized, notification.icon .. ' ' .. notification.level)
       table.insert(serialized, table.concat(notification.message, ' '))

       return table.concat(serialized, ' | ')
    end


    vim.keymap.set("n", "<leader>nn", function()
        fzf.fzf_exec(function(fzf_cb)
            for _, item in ipairs(require('notify').history()) do
                fzf_cb(serializeNotification(item))
            end
            fzf_cb()
        end, {})
    end)
end
