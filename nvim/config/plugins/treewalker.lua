return {
  'aaronik/treewalker.nvim',
  opts = {},
  cmd = { "Treewalker" },
  keys = {
    { '<C-k>',   '<cmd>Treewalker Up<cr>' },
    { '<C-j>',   '<cmd>Treewalker Down<cr>' },
    { '<C-l>',   '<cmd>Treewalker Right<cr>' },
    { '<C-h>',   '<cmd>Treewalker Left<cr>' },

    { '<C-S-k>', '<cmd>Treewalker SwapUp<cr>' },
    { '<C-S-j>', '<cmd>Treewalker SwapDown<cr>' },
    { '<C-S-l>', '<cmd>Treewalker SwapRight<cr>' },
    { '<C-S-h>', '<cmd>Treewalker SwapLeft<cr>' }
  }
}
