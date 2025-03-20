return {
  "folke/persistence.nvim",
  event = { "BufReadPre" },
  opts = {

  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end }
  },
  init = function()
    vim.api.nvim_create_autocmd("User",
      {
        pattern = "PersistenceSavePre",
        callback =

            function()
              -- If Neotree is open, close it

              -- vim.cmd 'Neotree close'

              -- Close any tabs with these filetypes
              local fts_to_match = { 'Neogit', 'Diffview' }

              -- Look for any windows with buffers that match fts_to_match
              local function should_close_tab(tabpage)
                local windows = vim.api.nvim_tabpage_list_wins(tabpage)
                for _, window in ipairs(windows) do
                  local buffer = vim.api.nvim_win_get_buf(window)
                  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer })
                  for _, v in ipairs(fts_to_match) do
                    if string.find(filetype, '^' .. v) then
                      return true
                    end
                  end
                end
                return false
              end

              -- Close any tabs that have the filetypes in fts_to_match
              local tabpages = vim.api.nvim_list_tabpages()
              for _, tabpage in ipairs(tabpages) do
                if should_close_tab(tabpage) then
                  local tabNr = vim.api.nvim_tabpage_get_number(tabpage)
                  vim.cmd('tabclose ' .. tabNr)
                end
              end
            end,
      }

    )
  end
}
