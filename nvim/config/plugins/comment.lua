return {
  'softvisio/Comment.nvim',
  lazy = false,
  branch = "fix/patch-treesitter",
  opts = {
    -- add any options here
  },
  config = function()
    require('Comment').setup()
    local ft = require('Comment.ft')
    ft.set('glimmer', { '{{!--%s--}}', '{{!--%s--}}' })
    ft.set('sparql', { '#' })
  end
}
