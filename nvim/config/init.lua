vim.g.closetag_filenames = '*.html, *.xhtml, *.gjs, *.gts, *.cshtml'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.opt.termguicolors = true
-- vim.opt.guicursor = ""
vim.opt.guicursor = "n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:blinkwait700-blinkoff400-blinkon250-ver40"
vim.g.title = true
vim.filetype.add({
  pattern = {
    ['.*%.hbs'] = 'glimmer',
  }
})

require("config.options")
require("lazy").setup("config.plugins", {
  rocks = { enabled = false },
  dev = {
    path = "~/.local/share/nvim/nix",
    fallback = false,
  }
})
require("config.bindings")
