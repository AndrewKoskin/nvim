-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- базовые настройки и клавиши
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.term") -- Терминал на <Leader>tt

-- подключаем все спецификации плагинов из lua/plugins/*
require("lazy").setup({ { import = "plugins" } })

