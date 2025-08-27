return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    { '<A-h>',   function() require('smart-splits').move_cursor_left() end },
    { '<A-j>',   function() require('smart-splits').move_cursor_down() end },
    { '<A-k>',   function() require('smart-splits').move_cursor_up() end },
    { '<A-l>',   function() require('smart-splits').move_cursor_right() end },

    { '<A-S-h>', function() require('smart-splits').swap_buf_left() end },
    { '<A-S-j>', function() require('smart-splits').swap_buf_down() end },
    { '<A-S-k>', function() require('smart-splits').swap_buf_up() end },
    { '<A-S-l>', function() require('smart-splits').swap_buf_right() end }
  },
  opts = {
    at_edge = false,
    float_win_behavior = 'mux'
  }

}
