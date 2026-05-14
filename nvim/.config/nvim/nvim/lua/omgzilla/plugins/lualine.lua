return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to show lazy pending updates

    local colors = {
      cyan = "#8BE9FD",
      green = "#50fa7b", 
      red = "#FF5555",
      orange = "#FFB86C",
      pink = "#FF79C6",
      purple = "#BD93F9",
      yellow = "#F1FA8C",
      bg = "#282A36",
      fg = "#F8F8F2",
      bright_blue = "#D6ACFF",
      bright_cyan = "#A4FFFF",
      bright_green = "#69FF94",
      bright_magenta = "#FF92DF",
      bright_red = "#FF6E6E",
      bright_yellow = "#FFFFA5",
      bright_white = "#FFFFFF",
      menu = "#21222C",
      selection = "#44475A",
      comment = "#6272A4",
      visual = "#3E4452",
      gutter_fg = "#4B5263",
      nontext = "#3B4048",
    }

    local dracula_theme = {
      normal = {
        a = { bg = colors.purple, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.purple, fq = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.pink, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      --inactive = {
      --  a = { bg = colors.*, fq = colors.bg, gui = "bold" },
      --  b = { bg = colors.bg, fq = colors.bg },
      --  c = { bg = colors.bg, fq = colors.bg },
      --},
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = dracula_theme,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.pink },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
