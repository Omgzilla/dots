return {
  "nvim-telescope/telescope.nvim",
  -- branch = "0.1.x",
  tag = "v0.2.2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local grep_args = { "--hidden", "--follow", "--glob", "!**/.git/*" }

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        file_ignore_patterns = { "^%.git/", "/%.git/" },
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
          find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!**/.git/*" },
        },
        grep_string = {
          additional_args = grep_args,
        },
        live_grep = {
          additional_args = grep_args,
        },
      },
      extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown({}),
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
  end,
}
