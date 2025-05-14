return {
  "okuuva/auto-save.nvim",
  version = '*',
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    condition = function(buf)
      local filetype = vim.fn.getbufvar(buf, "&filetype")
      if vim.list_contains({ "gitcommit" }, filetype) then
        return false
      end
      return true
    end
  },
  debounce_delay = 500
}
