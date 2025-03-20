return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  main = "render-markdown",
  opts = {},
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    local markdown = require("render-markdown")

    markdown.setup({
      enabled = true,
      file_types = { "markdown" },
      render_modes = { "n", "c" },
      max_file_size = 5.0,
    })
  end,
}
