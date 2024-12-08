return {
  'numToStr/Comment.nvim',
  lazy = false,
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
