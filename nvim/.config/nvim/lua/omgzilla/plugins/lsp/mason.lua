return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "cssls",
        "emmet_ls",
        "eslint",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "tailwindcss",
        "taplo",
        "yamlls",

        -- Optional: uncomment here to install and enable the server.
        -- Also enable the matching formatter/parser entries in conform.lua and nvim-treesitter.lua.
        -- "gopls", -- Go
        -- "astro", -- Astro
        -- "ts_ls", -- JavaScript/TypeScript completion and navigation; ESLint handles linting
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
           ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
      "b0o/SchemaStore.nvim",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua",  -- lua formatter
        "isort", -- python formatter
        "autopep8", -- python formatter
        "pylint", -- python linter
        -- "goimports", -- enable with the optional Go formatter in conform.lua
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
