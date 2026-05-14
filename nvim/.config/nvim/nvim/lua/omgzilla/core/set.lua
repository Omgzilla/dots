local set = {
  encoding = "utf-8",
  fileencoding = "utf-8", -- the encoding written to a file
  --shell = "zsh",
  mouse = "a", -- allow the mouse to be used in neovim
  title = true,
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  -- guicursor = "",
  -- guifont = "monospace:h17", -- the font used in graphical neovim applications

  winblend = 0,
  wildoptions = "pum",
  pumblend = 5,
  pumheight = 10, -- pop up menu height
  showmode = true, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 0, -- always show tabs
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)

  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines

  errorbells = false, -- sound durring an error
  cursorline = false, -- highlight the current line

  tabstop = 2, -- insert 2 spaces for a tab
  softtabstop = 2,
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  expandtab = true, -- convert tabs to spaces
  smartindent = true,
  autoindent = true, -- copy indentation from current line to new line

  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window

  wrap = true, -- False=display lines as one long line

  swapfile = false, -- creates a swapfile
  backup = false, -- creates a backup file
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  backupskip = "/tmp/*,/private/tmp/*",
  undodir = os.getenv("HOME") .. "/.cache/nvim",
  undofile = true, -- enable persistent undo

  hlsearch = false, -- highlight all matches on previous search pattern
  incsearch = true,
  ignorecase = true, -- ignore case in search patterns
  smartcase = true, -- smart case

  termguicolors = true, -- set term gui colors (most terminals support this)

  scrolloff = 10,
  sidescrolloff = 10,
  laststatus = 2,
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

  cmdheight = 1, -- Give more space for displaying messages.
  updatetime = 50, -- Having longer updatetime (default is 4000ms = 4s) leads to longer noticable delays and poor user experience
  lazyredraw = true, -- Don't redraw while executing macros (good performance config)
  colorcolumn = "80",
}

for key, value in pairs(set) do
  vim.opt[key] = value
end

local opt = vim.opt
opt.fillchars = vim.opt.fillchars + "eob: "
opt.fillchars:append({ stl = " ", })
opt.shortmess:append("c") -- Don't pass messages to |ins-completion-menu|.


vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("filetype plugin indent on")
vim.cmd("autocmd InsertLeave * set nopaste") -- Turn off paste mode when leaving insert

-- Run clipboard depending on OS
vim.cmd("\
if has('unix')\
    let s:uname = system('uname -s')\
    if s:uname == 'Darwin'\
        runtime ./macos.lua\
    endif\
endif\
")

vim.filetype.add({
  extension = {
    conf = "dosini",
  },
})
