local has_tide, tide = pcall(require, 'tide')

if has_tide then
    tide.setup({
        keys = {
            leader = ";",                         -- Leader key to prefix all Tide commands
            panel = ";",                          -- Open the panel (uses leader key as prefix)
            add_item = "a",                       -- Add a new item to the list (leader + 'a')
            delete = "d",                         -- Remove an item from the list (leader + 'd')
            clear_all = "x",                      -- Clear all items (leader + 'x')
            horizontal = "s",                     -- Split window horizontally (leader + '-')
            vertical = "v",                       -- Split window vertically (leader + '|')
        },
        animation_duration = 300,                 -- Animation duration in milliseconds
        animation_fps = 30,                       -- Frames per second for animations
        hints = {
            dictionary = "qwertzuiopfghjklycbnm", -- Key hints for quick access
        }
    })
end
