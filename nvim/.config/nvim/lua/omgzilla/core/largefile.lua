local M = {
  max_bytes = 1024 * 1024, -- 1 MiB of buffer text
}

function M.is_large(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  local size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
  return size > M.max_bytes
end

return M
