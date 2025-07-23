local has_harpoon, harpoon = pcall(require, "harpoon")
local has_snacks, snacks = pcall(require, "snacks")
local filemanager = require("fpetros.filemanager")

local M = {}
local _M = {}

M.can_setup = function()
    return has_harpoon and has_snacks
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Create Harpoon" })
    vim.keymap.set("n", "<leader>hh", _M.open_harpoon_picker, { desc = "List Harpoon" })

    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous Harpoon" })
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Next Harpoon" })
end

_M.open_harpoon_picker = function()
    filemanager.close_if_open(true)

    local items = harpoon:list().items

    for n, _ in ipairs(items) do
        items[n].file = items[n].value
        items[n].pos = { items[n].context.row, items[n].context.col }
    end

    snacks.picker({
        items = items,
        format = function(item)
            local line = {}

            if item.value then
                line[#line + 1] = { item.value, "SnacksPickerLabel" }
                return line
            end

            return {}
        end,
        confirm = function(picker, item)
            picker:close()
            harpoon:list():select(item.idx)
        end,
        actions = {
            delete_line = function(picker)
                local removeIdx = picker:selected({ fallback = true })[1].idx
                local copyList = harpoon:list().items
                harpoon:list():clear()
                for idx, item in ipairs(copyList) do
                    if removeIdx ~= idx then
                        harpoon:list():add(item)
                    end
                end
                picker:close()
                _M.open_harpoon_picker()
            end
        },
        win = {
            input = {
                keys = {
                    ['<C-x>'] = { "delete_line", mode = { "n", "i" } }
                }
            }
        }
    })
end

return M
