return {
  'bloznelis/before.nvim',
  dependencies = {
    -- { 'nvim-telescope/telescope.nvim', }
  },
  keys = {
    -- {
    --   "<C-h>",
    --   desc = "Jump to last edit"
    -- },
    --
    -- {
    --   "<C-l>",
    --   desc = "Jump to next edit"
    -- },
    -- {
    --   "<leader>oe",
    --   desc = "Jump to next edit"
    -- },
  },
  config = function()
    local before = require('before')
    before.setup({ history_size = 100 })

    -- -- Jump to previous entry in the edit history
    -- vim.keymap.set('n', '<C-h>', before.jump_to_last_edit, {})
    --
    -- -- Jump to next entry in the edit history
    -- vim.keymap.set('n', '<C-l>', before.jump_to_next_edit, {})

    -- Look for previous edits in telescope (needs telescope, obviously)
    -- vim.keymap.set('n', '<leader>oe', before.show_edits_in_telescope, {})
  end
}
