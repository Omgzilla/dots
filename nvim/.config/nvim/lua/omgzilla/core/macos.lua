-- Description: Use macOS clipboard to copy/paste
if vim.uv.os_uname().sysname == "Darwin" then
  vim.opt.clipboard = "unnamedplus"
end
