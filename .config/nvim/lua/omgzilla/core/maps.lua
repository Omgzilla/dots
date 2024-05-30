---------------
-- Keybindings
---------------

local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true})
end


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

-- File Explorer
map("n", "<leader>pv", vim.cmd.Ex)

-- Enable/Disable numbers
map("n", "<leader>n", ":set invrnu invnu<CR>")

-- Yes/No to signcolumn
map("n", "<leader>c", ":set signcolumn=yes<CR>")
map("n", "<leader>C", ":set signcolumn=no<CR>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
-- Scroll half page at a time
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

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

-- Telescope
--map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>")
--map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
--map("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
--map("n", "<leader>fw", "<CMD>Telescope live_grep<CR>")
--map("n", "<leader>ht", "<CMD>Telescope colorscheme<CR>")

-- Replace words
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Set run priv on file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Toggle transparent
map("n", "<leader>b", "<CMD>TransparentToggle<CR>")

-- Press jk fast to exit insert mode 
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<ESC>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")
