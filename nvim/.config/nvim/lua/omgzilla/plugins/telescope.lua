return {
  "nvim-telescope/telescope.nvim",
  -- branch = "0.1.x",
  tag = "v0.2.2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          follow = true,
        },
        grep_string = {
          hidden = true,
          follow = true,
        },
        live_grep = {
          hidden = true,
          follow = true,
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>ff", function()
        require("telescope.builtin").find_files({
          additional_args = {
            "--glob",
            "!**/.git/*"
          },
        })
      end, { desc = "Fuzzy find files in cwd" })

      keymap.set("n", "<leader>fr", function()
        require("telescope.builtin").oldfiles({
          additional_args = {
            "--glob",
            "!**/.git/*",
          },
        })
      end, { desc = "Fuzzy find recent files" })

      keymap.set("n", "fs", function()
        require("telescope.builtin").live_grep({
          additional_args = {
            "--hidden",
            "--follow",
            "--glob",
            "!**/.git/*",
          },
        })
      end, { desc = "Find string in cwd" })

      keymap.set("n", "fc", function()
        require("telescope.builtin").grep_string({
          additional_args = {
            "--hidden",
            "--follow",
            "--glob",
            "!**/.git/*",
          },
        })
      end, { desc = "Find string under cursor in cwd" })
  end,
}
