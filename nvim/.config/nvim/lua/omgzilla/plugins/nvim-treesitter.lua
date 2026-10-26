return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
  },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    local largefile = require("omgzilla.core.largefile")

    treesitter.setup()

    treesitter.install({
      "bash",
      "css",
      "dockerfile",
      "gitignore",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "query",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",

      -- Optional language parsers. Go and Astro have matching servers in lsp/mason.lua.
      -- "go",
      -- "gomod",
      -- "gosum",
      -- "gowork",
      -- "astro",
      -- "make", -- highlighting only; :make and :copen already work without extra plugins
      -- TypeScript/TSX parsers are already enabled above.
    })

    vim.filetype.add({
      extension = {
        mdx = "mdx",
      },
    })
    vim.treesitter.language.register("markdown", "mdx")
    vim.treesitter.language.register("bash", "zsh")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(args)
        if largefile.is_large(args.buf) then
          pcall(vim.treesitter.stop, args.buf)
          return
        end
        pcall(vim.treesitter.start, args.buf)
      end,
    })

  end,
}
