local has_harpoon, harpoon = pcall(require, "harpoon")
local has_fzf, fzf = pcall(require, "fzf-lua")
local has_utils, utils = pcall(require, "fzf-lua.utils")
local has_path, path = pcall(require, "fzf-lua.path")
local has_builtin, builtin = pcall(require, 'fzf-lua.previewer.builtin')

local M = {}

M.can_setup = function()
    return has_harpoon and has_fzf and has_builtin and has_utils and has_path
end

M.setup = function()
    if not M.can_setup() then
        return
    end

    local line_aware_previewer = builtin.base:extend()

    function line_aware_previewer:new(o, opts, fzf_win)
        line_aware_previewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, line_aware_previewer)
        return self
    end

    function line_aware_previewer:populate_preview_buf(entry_str)
        if utils.file_is_readable(entry_str) then
            local tmpbuf = self:get_tmp_buffer()
            local list_item, _ = harpoon:list():get_by_value(entry_str)

            utils.read_file_async(entry_str, vim.schedule_wrap(function(data)
                local lines = vim.split(data, "[\r]?\n")

                if data:sub(#data, #data) == "\n" or data:sub(#data - 1, #data) == "\r\n" then
                    table.remove(lines)
                end

                vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)

                self:set_preview_buf(tmpbuf)

                local tempname = path.join({ tostring(tmpbuf), entry_str })
                vim.api.nvim_buf_set_name(tmpbuf, tempname)
                vim.api.nvim_buf_call(tmpbuf, function() vim.cmd('filetype detect') end)

                vim.api.nvim_win_set_cursor(self.win.preview_winid, {
                    list_item.context.row or 1,
                    list_item.context.col or 0,
                })
            end))
        end
    end

    function line_aware_previewer:gen_winopts()
        local new_winopts = {
            wrap   = false,
            number = true
        }
        return vim.tbl_extend("force", self.winopts, new_winopts)
    end

    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Create Harpoon" })
    vim.keymap.set("n", "<leader>hh", function()
            fzf.fzf_exec(function(fzf_cb)
                for _, item in ipairs(harpoon:list().items) do
                    fzf_cb(item.value)
                end
                fzf_cb()
            end, {
                previewer = line_aware_previewer,
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

return M
