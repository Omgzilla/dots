return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "isort", "autopep8" },
        toml = { "taplo" },
        yaml = { "prettier" },

        -- Optional: also uncomment the matching Mason entries in lsp/mason.lua.
        -- go = { "goimports" }, -- installs goimports through mason-tool-installer
        -- astro = { "prettier" }, -- project needs prettier-plugin-astro installed and configured
        -- typescript = { "prettier" },
        -- typescriptreact = { "prettier" },
      },
      format_on_save = false,
      -- format_on_save = {
      --   lsp_fallback = true,
      --   async = false,
      --   timeout_ms = 1000,
      -- },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
