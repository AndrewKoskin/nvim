-- plugins/auto_session.lua
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- эта хрень нужна, предупреждение на checkhealth убирает, без нее не особо корректно сессии подтягиваются походу

return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup {
      log_level = "info",  -- уровень логов
      auto_session_enable_last_session = false,  -- не восстанавливать последнюю сессию глобально
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/", -- где хранятся сессии
      auto_session_enabled = true,
      auto_save_enabled = true,    -- сохранять автоматически при выходе
      auto_restore_enabled = true, -- восстанавливать автоматически при старте Neovim
      pre_save_cmds = { "Neotree close" },        -- если используешь Neotree, закрыть перед сохранением
      --post_restore_cmds = { "Neotree reveal" },   -- открыть после восстановления
    }

    -- Опционально: команды для ручного управления сессиями
    vim.api.nvim_create_user_command("SaveSession", function()
      require("auto-session.session-lens").save_session()
    end, {})

    vim.api.nvim_create_user_command("RestoreSession", function()
      require("auto-session.session-lens").restore_session()
    end, {})
  end
}

