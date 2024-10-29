return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      globalstatus = false,
    },
    sections = { lualine_c = { { 'filename', path = 0 } } },
    extensions = { 'neo-tree' }
  }
}
