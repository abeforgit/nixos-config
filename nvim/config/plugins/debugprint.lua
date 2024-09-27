-- logging spec for debugprint
local js_like = {
  left = 'console.info("',
  right = '")',
  mid_var = '", ',
  right_var = ")",
}
return {
  "andrewferrier/debugprint.nvim",

  -- opts = { … },

  -- The 'keys' and 'cmds' sections of this configuration will need to be changed if you
  -- customize the keys/commands.

  opts = {
    filetypes = {
      ["javascript"] = js_like,
      ["javascriptreact"] = js_like,
      ["javascript.glimmer"] = js_like,
      ["typescript"] = js_like,
      ["typescriptreact"] = js_like,
      ["typescript.glimmer"] = js_like,
    },
  },
  keys = {
    { "g?", mode = 'n' },
    { "g?", mode = 'x' },
  },
  cmd = {
    "ToggleCommentDebugPrints",
    "DeleteDebugPrints",
  },
}
