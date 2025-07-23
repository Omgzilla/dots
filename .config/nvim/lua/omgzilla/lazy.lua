local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "omgzilla.plugins" },
  { import = "omgzilla.plugins.lsp" },
}, {
  install = {
    --colorscheme = { "dracula" },
    colorscheme = { "catppuccin-mocha" },
  },
  checker = {
    enabled = true, -- automatic update checker
    notify = false, -- don't notify about updates
  },
  change_detection = {
    notify = false, -- don't notify about changes
  },
})
