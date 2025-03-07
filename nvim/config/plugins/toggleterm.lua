return {
  'akinsho/toggleterm.nvim',
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermSelect" },
  opts = {
    open_mapping = [[<C-\>]],
    autochdir = true
  },
  keys = {
    { "<leader>ot", "<cmd>ToggleTerm<CR>", mode = { "n" } },
    { "<esc>",      "<cmd>ToggleTerm<CR>", mode = { "t" } },
    { "<C-\\>",     "<cmd>ToggleTerm<CR>", mode = { "n" } },
    { "<C-w>",      "<C-\\><C-n><C-w>",    mode = { "t" } }

  }

}
