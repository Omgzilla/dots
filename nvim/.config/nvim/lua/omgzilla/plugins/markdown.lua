return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local markdown = require("render-markdown")
    markdown.setup({
      enabled = true,
      render_modes = { "n", "c" }, -- modes to render
      position = 'inline',
      file_types = { "markdown" },
      max_file_size = 5.0,
      completions = {
        lsp = { enabled = true }
      },
    })
  end,
}
