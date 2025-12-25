TABLINE_COLOR_MAP = {
  ["nixos-config"] = "#5a9ee8",
  ["ember-rdfa-editor"] = "c2bce6",

  ["ember-rdfa-editor-lblod-plugins"] = '#96cf59',
  ["app-gelinkt-notuleren"] = '#0f5c39',
  ["frontend-gelinkt-notuleren"] = '#69591c',
  -- [""] = '#eda596',
  -- ["/home/arne/repos/nixos-config"] = '#e2ecf4',
  -- ["/home/arne/repos/nixos-config"] = '#972b6c',
  -- ["/home/arne/repos/nixos-config"] = '#64257e'
}
SW = 0
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
    tabline = {
      lualine_a = { { 'windows', use_mode_colors = true, disabled_buftypes = { 'quickfix', 'prompt', 'nofile' } } },
      -- lualine_b = { 'branch' },
      -- lualine_c = { 'filename' },
      lualine_x = {},
      lualine_y = {},

      lualine_z = { {
        'tabs',
        tab_max_length = 200000,
        max_length = vim.o.columns * 2 / 3,
        mode = 2,
        path = 2,
        fmt = function(name)
          local root = vim.fs.root(name, { '.git', '.config' })
          return vim.fn.fnamemodify(root, ':t')
        end,

        -- color = function(section)
        --   local currentTabdir = vim.fn.getcwd(-1, 0)
        --   local mappedColor = TABLINE_COLOR_MAP[currentTabdir]
        --   if (mappedColor) then
        --     local output = { fg = mappedColor, bg = mappedColor, gui = 'italic' }
        --     -- vim.print(output)
        --     return output
        --   end
        --
        --   return nil
        -- end
        tabs_color = {
          active = function()
            local tabDir = vim.fn.getcwd(-1, 0)
            local splitPath = vim.split(tabDir, '/', { trimempty = true })
            local projName = splitPath[#splitPath]
            local tabColor = TABLINE_COLOR_MAP[projName]
            if (tabColor) then
              return { bg = tabColor }
            else
              local randomR = string.format("%x", math.random(0, 255))
              local randomG = string.format("%x", math.random(0, 255))
              local randomB = string.format("%x", math.random(0, 255))
              local color = '#' .. randomR .. randomG .. randomB
              TABLINE_COLOR_MAP[projName] = color
              return { bg = color }
            end
          end
        }
      } },
    },
    extensions = { 'lazy', 'trouble', 'oil' }
  }
}
