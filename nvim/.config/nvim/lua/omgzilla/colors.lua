vim.opt.background = "dark"
local colorscheme = "dracula"

-- Take a look at:
-- https://github.com/RRethy/nvim-base16
-- https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/nvim/lua/dt/highlights.lua

-- dracula --
--vim.g.dracula_show_end_of_buffer = true -- show the '~' characters after the end of buffers
--vim.g.dracula_transparent_bg = true -- use transparent background
--vim.g.dracula_lualine_bg_color = "#44475a" -- set custom lualine background color
--vim.g.dracula_italic_comment = true -- set italic comment
--vim.g.dracula_colors = { -- customize dracula color palette
--  bg = "#282A36",
--  fg = "#F8F8F2",
--  selection = "#44475A",
--  comment = "#6272A4",
--  red = "#FF5555",
--  orange = "#FFB86C",
--  yellow = "#F1FA8C",
--  green = "#50fa7b",
--  purple = "#BD93F9",
--  cyan = "#8BE9FD",
--  pink = "#FF79C6",
--  bright_red = "#FF6E6E",
--  bright_green = "#69FF94",
--  bright_yellow = "#FFFFA5",
--  bright_blue = "#D6ACFF",
--  bright_magenta = "#FF92DF",
--  bright_cyan = "#A4FFFF",
--  bright_white = "#FFFFFF",
--  menu = "#21222C",
--  visual = "#3E4452",
--  gutter_fg = "#4B5263",
--  nontext = "#3B4048",
--}

-- tokyonight --
--vim.g.tokyonight_transparent = true
--vim.g.tokyonight_transparent_sidebar = true

-- neosolarized --
--vim.g.neosolarized_termtrans = 1
--vim.g.neosolarized_contrast = "normal"
--vim.g.neosolarized_visibility = "normal"
--vim.g.neosolarized_vertSplitBgTrans = 1
--vim.g.neosolarized_bold = 1
--vim.g.neosolarized_underline = 1
--vim.g.neosolarized_italic = 0
--vim.g.neosolarized_termBoldAsBright = 1

-- Highlight the region on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = num_au,
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
	end,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
