-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function toggle_fetch_terminal()
  Snacks.terminal.toggle(nil, {
    interactive = true,
    env = { SNACKS_TERM = "1" },
  })
end

vim.keymap.set("n", "<C-/>", toggle_fetch_terminal, { desc = "Toggle Terminal" })
vim.keymap.set("t", "<C-_>", toggle_fetch_terminal, { desc = "Toggle Terminal" })
