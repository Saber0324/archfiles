-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("GhosttyTerminalSetup", { clear = true }),
  callback = function()
    -- Tell Fastfetch and terminal tools that they are still inside Ghostty
    vim.env.TERM = "xterm-ghostty"
    vim.env.GHOSTTY_RESOURCES_DIR = vim.env.GHOSTTY_RESOURCES_DIR or ""
  end,
})
