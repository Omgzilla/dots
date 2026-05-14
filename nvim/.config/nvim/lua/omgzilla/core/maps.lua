---------------
-- Keybindings
---------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local map = vim.keymap.set
-- Toggle transparent
map("n", "<leader>b", "<CMD>TransparentToggle<CR>", { desc = "Toggle transparent background" })

-- Enable/Disable numbers
map("n", "<leader>n", ":set invrnu invnu<CR>", { desc = "Toggle numbers" })

-- Yes/No to signcolumn
map("n", "<leader>c", ":set signcolumn=yes<CR>", { desc = "Enable Signcolumn" })
map("n", "<leader>C", ":set signcolumn=no<CR>", { desc = "Disable Signcolumn" })

-- Window management
-- split windows
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
-- tab windows
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in a new tab" })
-- better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to Right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to Down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to Up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to Left window" })
-- scroll half page at a time
map("n", "<C-d>", "<C-d>zz", { desc = "Navigate half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Navigate half page up" })
-- resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })
-- navigate buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Navigate to next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Navigate to previous buffer" })

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Keep pasting same
map("x", "<leader>p", '"_dP', { desc = "Paste same yank" })
-- Copy to clipboard (not buffer)
map("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- Move text up and down
map("v", "S-j", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "S-k", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Replace words
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace selected word/s" })

-- Set run priv on file
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Set +x execute mod to file" })

-- Press jk fast to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<C-c>", "<ESC>", { desc = "Exit insert mode" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Decrease indentation" })
map("v", ">", ">gv", { desc = "Increase indentation" })
