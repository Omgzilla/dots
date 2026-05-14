return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    options = {
      background = "dark",
    },
  },
  config = function ()
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
