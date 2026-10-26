return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "mdx" },
  keys = {
    {
      "<leader>tm",
      function()
        require("render-markdown").buf_toggle()
      end,
      ft = { "markdown", "mdx" },
      desc = "Toggle Markdown rendering",
    },
  },
  opts = {
    enabled = false,
    render_modes = true, -- keep the chosen view when changing modes
    anti_conceal = { enabled = false },
    file_types = { "markdown", "mdx" },
    max_file_size = 5.0,
    completions = {
      lsp = { enabled = true },
    },
  },
}
