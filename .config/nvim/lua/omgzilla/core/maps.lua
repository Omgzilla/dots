---------------
-- Keybindings
---------------

-- local function map(m, k, v, d)
--     vim.keymap.set(m, k, v, { silent = true })
-- end

local map = vim.keymap.set

--Remap space as leader key
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Enable/Disable numbers
map("n", "<leader>n", ":set invrnu invnu<CR>", { desc = "Toggle numbers" })

-- Yes/No to signcolumn
map("n", "<leader>c", ":set signcolumn=yes<CR>", "Enable signcolumn")
map("n", "<leader>C", ":set signcolumn=no<CR>", "Disable signcolumn")

-- Better window navigation
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-l>", "<C-w>l")
-- Scroll half page at a time
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")

-- Navigate wim panes better
map("n", "<C-k", ":wincmd k<CR>")
map("n", "<C-j", ":wincmd j<CR>")
map("n", "<C-h", ":wincmd h<CR>")
map("n", "<C-l", ":wincmd l<CR>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window


keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
-- Resize with arrows(macOS)
map("n", "<M-Up>", ":resize -2<CR>")
map("n", "<M-Down>", ":resize +2<CR>")
map("n", "<M-Left>", ":vertical resize -2<CR>")
map("n", "<M-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Keep pasting same
map("x", "<leader>p", "\"_dP")
-- Copy to clipboard (not buffer)
map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+Y")

-- Move text up and down
map("n", "J", ":m '>+1<CR>gv=gv")
map("n", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")

-- Replace words
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Set run priv on file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Toggle transparent
map("n", "<leader>b", "<CMD>TransparentToggle<CR>")

-- Press jk fast to exit insert mode 
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<ESC>")
