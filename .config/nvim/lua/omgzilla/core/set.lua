local set = {
    -- General
    encoding = "utf-8", -- default encoding
    fileencoding = "utf-8", -- the encoding written to a file
    --shell = "zsh", -- default shell
    mouse = "a", -- allow the mouse to be used in neovim
    title = true, -- enable title
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    guicursor = "",
    guifont = "monospace:h17", -- the font used in graphical neovim applications
    errorbells = false, -- sound durring an error
    winblend = 0,
    wildoptions = "pum",
    pumblend = 5,
    pumheight = 10, -- pop up menu height
    showmode = true, -- we don't need to see things like -- INSERT -- anymore
    showtabline = 0, -- always show tabs
    timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
    cmdheight = 1, -- give more space for displaying messages.
    cursorline = false, -- highlight the current line
    colorcolumn = "100", -- show a colorcolumn line after # characters
    wrap = false, -- wrap lines to fit window size

    -- colorscheme
    termguicolors = true, -- set term gui colors (most terminals support this)
    background = "dark" -- colorschemes that can be light or dark will be made dark
    signcolumn = "yes" -- show sign column so that text doesn't shift

    -- tabs & indentation
    tabstop = 2, -- insert 2 spaces for a tab
    softtabstop = 2,
    shiftwidth = 2, -- the number of spaces inserted for each indentation
    expandtab = true, -- convert tabs to spaces
    smartindent = true,
    autoindent = true, -- copy indent from current line when starting new one

     -- search settings
    hlsearch = false, -- highlight all matches on previous search pattern
    incsearch = true,
    ignorecase = true, -- ignore case in search patterns
    smartcase = true, -- smart case

    -- split windows
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window

    -- backups settings
    swapfile = false, -- creates a swapfile
    backup = false, -- creates a backup file
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    backupskip = "/tmp/*,/private/tmp/*",
    undodir = os.getenv("HOME") .. "/.cache/nvim", -- path for undo history
    undofile = true, -- enable persistent undo

    -- scroll settings
    scrolloff = 10, -- always show # of lines when scrolling
    sidescrolloff = 10, -- always show # characters when side scrolling
    laststatus = 2,
    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
 
    -- perfomance settings
    updatetime = 100, -- having longer updatetime (default is 4000ms = 4s) leads to longer noticable delays and poor user experience
    lazyredraw = true, -- don't redraw while executing macros (good performance config)
}

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.opt.fillchars.eob = " "
-- vim.opt.fillchars = vim.opt.fillchars + "vertleft: "
-- vim.opt.fillchars = vim.opt.fillchars + "vertright: "
vim.opt.fillchars = vim.opt.fillchars + 'eob: '
vim.opt.fillchars:append {
  stl = ' ',
}

vim.opt.shortmess:append("c") -- don't pass messages to |ins-completion-menu|.

for key, value in pairs(set) do
  vim.opt[key] = value
end

vim.cmd("let g:netrw_liststyle = 3")
vim.cmd "filetype plugin indent on"
vim.cmd "autocmd InsertLeave * set nopaste" -- turn off paste mode when leaving insert

-- Run clipboard depending on OS
vim.cmd "\
  if has('unix')\
    let s:uname = system('uname -s')\
    if s:uname == 'Darwin'\
        runtime ./macos.lua\
    endif\
  endif\
  if has('win32')\
    runtime ./win.lua\
  endif\
  "

vim.filetype.add {
  extension = {
    conf = "dosini",
  },
}
