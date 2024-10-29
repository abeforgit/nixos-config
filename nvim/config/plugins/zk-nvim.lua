return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "telescope"
    })
  end,
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
