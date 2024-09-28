local hasHarpoon, harpoon = pcall(require, "harpoon")
local hasFzf, fzf = pcall(require, "fzf-lua")

if hasHarpoon and hasFzf then
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Create Harpoon" })
    vim.keymap.set("n", "<leader>hh", function()
            fzf.fzf_exec(function(fzf_cb)
                for _, item in ipairs(harpoon:list().items) do
                    fzf_cb(item.value)
                end
                fzf_cb()
            end, {
                previewer = "builtin",
                actions = {
                    ['default'] = function(selected)
                        local _, idx = harpoon:list():get_by_value(selected[1])
                        harpoon:list():select(idx)
                    end,
                    ['ctrl-x'] = {
                        function(selected)
                            local _, removeIdx = harpoon:list():get_by_value(selected[1])
                            local copyList = harpoon:list().items
                            harpoon:list():clear()
                            for idx, item in ipairs(copyList) do
                                if removeIdx ~= idx then
                                    harpoon:list():add(item)
                                end
                            end
                        end,
                        fzf.actions.resume
                    }
                }
            })
        end,
        { desc = "List Harpoon" })

    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous Harpoon" })
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Next Harpoon" })
end
