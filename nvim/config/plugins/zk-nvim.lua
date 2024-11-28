return {
  "zk-org/zk-nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  opts = {

    picker = "fzf_lua",
  },
  main = "zk",
  cmd = {
    "ZkNew", "ZkNotes", "ZkTags", "ZkMatch"
  },
  keys = {
    {
      '<leader>zn',
      "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>"
    }
  }
}
