return {
  { import = "plugins.lsp" },
  { import = "plugins.treesitter" },
  { import = "plugins.go" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },
  { import = "plugins.ui" },
  { import = "plugins.files" },
  { import = "plugins.comment" },
  { import = "plugins.autopairs" },
  { import = "plugins.navic"}, -- Штука для выведения родительской функции на верх
  { import = "plugins.lualine"}, -- Для отображения текущей функции/класса
  { import = "plugins.auto_session"}, -- Для сохранения сессий между запусками nvim
  -- { import = "plugins.run"} -- Для запуска файлов, не работает()
}

