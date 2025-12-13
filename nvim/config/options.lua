vim.system({ 'mkdir', '/home/arne/.local/share/nvim/_undo' },
  {}):wait()

local o = vim.o
local opt = vim.opt
o.exrc = true
o.shell = '/etc/profiles/per-user/arne/bin/zsh'
o.number = true
o.textwidth = 0
o.showmatch = true
o.visualbell = true
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true
-- o.autoindent = true
o.shiftwidth = 2
o.smartindent = true
o.smarttab = true
o.softtabstop = 2
o.ruler = true
o.undolevels = 1000
o.backspace = 'indent,eol,start'
o.autoread = true
opt.clipboard:append { "unnamedplus" }
-- o.signcolumn = 'number'
o.updatetime = 300
o.undodir = '/home/arne/.local/share/nvim/_undo'
o.undofile = true
o.title = true
o.titlestring = '%f%( [%M]%) - NVIM'
o.linebreak = true
o.relativenumber = true
o.number = true
o.breakindent = true
o.showbreak = '↪ '
o.hidden = true
o.scrolloff = 3
o.termguicolors = true
-- o.cmdheight = 0
o.sessionoptions = "curdir,folds,winsize,winpos,terminal,localoptions"

vim.api.nvim_create_autocmd("UIEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("if exists('g:started_by_firenvim')\nset guifont=0xproto_Nerd_Font:h18\nendif")
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(args)
    vim.opt_local.conceallevel = 2
  end
})
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.o.guifont = "0xproto_Nerd_Font:h16"
if vim.g.started_by_firenvim == true then
  vim.g.auto_session_enabled = false
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = "*_sparql_*.txt",
    command = "set filetype=sparql"
  })
  vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
      ["https?.*/sparql"] = {
        priority = 1,
        filename = "/tmp/{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.sparql",
        takeover = "never"
      },
      [".*"] = {
        cmdline  = "neovim",
        content  = "text",
        priority = 0,
        selector = "textarea",
        takeover = "never"
      },
    }
  }
  vim.api.nvim_set_keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", {})
else
end
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)
  -- vim.g.neovide_cursor_hack = true
  vim.g.neovide_cursor_animation_length = 0.100
  vim.g.neovide_cursor_short_animation_length = 0.02
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
  vim.o.guifont = "Fira Code,Noto_Color_Emoji:h12"
end
-- let g:firenvim_config = {
--     \ 'globalSettings': {
--         \ 'alt': 'all',
--     \  },
--     \ 'localSettings': {
--         \ '.*': {
--             \ 'cmdline': 'neovim',
--             \ 'priority': 0,
--             \ 'selector': 'textarea',
--             \ 'takeover': 'always',
--         \ },
--     \ }
-- \ }
-- let fc = g:firenvim_config['localSettings']
-- let fc['.*'] = { 'takeover': 'never' }

-- theme
-- require('bamboo').load()
