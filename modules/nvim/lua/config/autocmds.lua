-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if vim.g.vscode then
  return {}
end

--  --  e.g. ~/.local/share/chezmoi/*
--  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--    pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
--    callback = function(ev)
--      local bufnr = ev.buf
--      local edit_watch = function()
--        require("chezmoi.commands.__edit").watch(bufnr)
--      end
--      vim.schedule(edit_watch)
--    end,
--  })

--
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  pattern = "*",
  callback = function()
    require("config.statusline")
    vim.opt_local.statusline = "%!v:lua.Statusline.active()"
  end,
})
