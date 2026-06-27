return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "cssls",
        "emmet_ls",
        "eslint-lsp",
        "html",
        "lua_ls",
        "pyright",
        "tailwindcss",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
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
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua",  -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "autopep8", -- python formatter
        "pylint", -- python linter
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
