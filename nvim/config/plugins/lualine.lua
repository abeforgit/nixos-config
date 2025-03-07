return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      globalstatus = false,
      always_divide_middle = false,
    },
    sections = {
      lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = { { 'filename', path = 0 } },

      lualine_x = { { 'filetype', icon_only = true } },
      lualine_y = {},
      lualine_z = {}
    },
    extensions = { 'neo-tree' }
  }
}
