return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({

      rememberBuffers = false,
      mappings = {
        -- builtin mappings
        "livewire",
        "angular",
        "laravel",
        "rails",
        "golang",
        "python",
        "rust",
        -- custom mapping
        {
          pattern = "/components/(.*)%..*$",
          target = "/components/%1.*",
          context = "component",
        },

        {
          pattern = "/controllers/(.*)%..*$",
          target = {
            {
              target = "/templates/%1.hbs",
              context = "template",
            },
            {
              target = "/routes/%1.*",
              context = "route",
            },
          },
        },
        {
          pattern = "/routes/(.*)%..*$",
          target = {
            {
              target = "/templates/%1.hbs",
              context = "template",
            },
            {
              target = "/controllers/%1.*",
              context = "controller",
            }
          },
        },
        {
          pattern = "/templates/(.*)%.hbs$",
          target = {
            {
              target = "/routes/%1.*",
              context = "route",
            },
            {
              target = "/controllers/%1.*",
              context = "controller",
            }
          },
        },
      },
      transformers = {
        -- defining a custom transformer
        lowercase = function(inputString)
          return inputString:lower()
        end
      },
      style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2
      },
    })
  end,
  commands = { "Other", "OtherTabNew", "OtherSplit", "OtherVSplit", "OtherClear" },

  keys = {
    {
      "<leader>oo",
      "<cmd>Other<CR>",
      desc = "Open related file"
    },

  }


}
