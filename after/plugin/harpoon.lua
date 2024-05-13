local harpoon = require("harpoon")
local config = require('telescope.config').values
local action_state = require("telescope.actions.state")

local listName = 'main'
local actions = {}

harpoon:setup({
    settings = {
        sync_on_ui_close = false
    }
})

harpoon:list(listName)

actions.remove = function(_prompt_bufnr)
    local picker = action_state.get_current_picker(_prompt_bufnr)
    if picker ~= nil then
        local selection = action_state.get_selected_entry()
        for index, item in ipairs(harpoon:list(listName).items) do
            if selection.value == item.value then
                harpoon:list(listName):remove_at(index)
                break
            end
        end
        require('telescope.actions').close(_prompt_bufnr)
        actions.toggle_telescope()
    end
end

actions.create_finder = function()
    local file_paths = {}
    for _, item in ipairs(harpoon:list(listName).items) do
        table.insert(file_paths, item.value)
    end
    return require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = config.file_previewer({}),
        sorter = config.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<C-d>", actions.remove)
            map("n", "<C-d>", actions.remove)
            return true
        end
    })
end

actions.toggle_telescope = function()
    actions.create_finder():find()
end

vim.keymap.set('n', '<leader>ha', function() harpoon:list(listName):add() end, { desc = "Create Harpoon" })
vim.keymap.set('n', '<leader>hn', function() harpoon:list(listName):next() end, { desc = "Next Harpoon" })
vim.keymap.set('n', '<leader>hp', function() harpoon:list(listName):prev() end, { desc = "Previous Harpoon" })
vim.keymap.set("n", "<leader>hh", function() actions.toggle_telescope() end,
    { desc = "Open harpoon window" })
