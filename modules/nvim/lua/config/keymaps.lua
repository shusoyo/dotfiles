-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--[[

          ↑
          i
     ← j    l →
         k
         ↓
--]]
local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }
local mappings = {
  --   { from = "h",     to = "i" },
  --   { from = "i",     to = "k" },
  --   { from = "k",     to = "j" },
  --   { from = "j",     to = "h" },
  { from = "<C-S>", to = ":w<CR>" },
}

for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
end
