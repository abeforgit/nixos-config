local function save_and_quit()
  local oil = require("oil");
  oil.save(nil, function(err)
    if not err then
      oil.close()
    end
  end);
end

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["q"] = {
        callback = save_and_quit,
        mode = "n"
      }
    },
  },
  keys = {
    { "<leader>fo", "<cmd>Oil --float<CR>", desc = "Open oil for buffer" }
  },
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
