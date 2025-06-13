local excluded_filetypes = {
  "gitcommit",
  -- should normally be non-modifiable, but just in case
  "NvimTree",
  "Outline",
  "TelescopePrompt",
  "alpha",
  "dashboard",
  "lazygit",
  "neo-tree",
  "oil",
  "prompt",
  "toggleterm",
}
local excluded_filenames = {
}

local save_condition = function(buf)
  if vim.g.started_by_firenvim == true then
    print("disabling save")
    return false
  end
  local fn = vim.fn
  local utils = require("auto-save.utils.data")

  if
      utils.not_in(fn.getbufvar(buf, "&filetype"), excluded_filetypes)
      and utils.not_in(fn.expand("%:t"), excluded_filenames)
  then
    return true -- met condition(s), can save
  end
  return false  -- can't save
end


return {
  "okuuva/auto-save.nvim",
  version = '*',
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged", "BufLeave", "FocusLost" },
  opts = {
    enabled = false,
    trigger_events = {                          -- See :h events
      immediate_save = immediate_triggers,      -- vim events that trigger an immediate save
      defer_save = deferred_triggers,           -- vim events that trigger a deferred save (saves after `debounce_delay`)
      cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
    },
    condition = save_condition,
    debounce_delay = 1000
  },
}
