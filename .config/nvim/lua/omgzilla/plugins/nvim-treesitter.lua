return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      local autotag = require("nvim-ts-autotag")
      autotag.setup({
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = {
          enable = true,
        }
      })
      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "gitignore",
          "html",
          "json",
          "javascript",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "scss",
          "toml",
          "vim",
          "yaml",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
      -- use bash parser for zsh files
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
}
