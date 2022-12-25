vim.cmd "highlight Warn guifg=#FF79C6 guibg=#191A21"
vim.cmd "highlight Norm guifg=#ABB2BF guibg=#191A21"
local function mode()
    local modes = {
      ["n"] = "NORMAL",
      ["no"] = "NORMAL",
      ["v"] = "VISUAL",
      ["V"] = "VISUAL LINE",
      [""] = "VISUAL BLOCK",
      ["s"] = "SELECT",
      ["S"] = "SELECT LINE",
      [""] = "SELECT BLOCK",
      ["i"] = "INSERT",
      ["ic"] = "INSERT",
      ["R"] = "REPLACE",
      ["Rv"] = "VISUAL REPLACE",
      ["c"] = "COMMAND",
      ["cv"] = "VIM EX",
      ["ce"] = "EX",
      ["r"] = "PROMPT",
      ["rm"] = "MOAR",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERMINAL",
    }
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format("[%s]", modes[current_mode]):upper()
end

function status_line()
    return table.concat {
       -- "%#StatusWarn#",
        "%t", -- File name 
        "%=", -- Space
        "%y", -- Type of file
        "%k", -- Keymap 
        "[%l/%L]", -- Line number
        "[%c]", -- Column number
        "%#Warn#%r", -- Read only [RO]
        "%#Norm#",
        mode(),
        "%p%%"
    }
end

vim.o.statusline = "%!luaeval('status_line()')"
