return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local largefile = require("omgzilla.core.largefile")

    lint.linters_by_ft = {
      nix = { "statix" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local function try_linting(automatic)
      if automatic and largefile.is_large(0) then
        return
      end
      local linters = lint.linters_by_ft[vim.bo.filetype]

      lint.try_lint(linters)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        try_linting(true)
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      try_linting()
    end, { desc = "Trigger linting for current file" })
  end,
}
