return {
  { "stevearc/overseer.nvim", event = "VeryLazy",
    config = function()
      local overseer = require("overseer")
      overseer.setup({}) -- дефолта достаточно

      -- Команда для текущего файла по filetype
      local function run_cmd_for_current_file(extra_args)
        local ft = vim.bo.filetype
        local file = vim.fn.expand("%")
        local cmds = {
          go         = "go run " .. vim.fn.fnameescape(file),
          python     = "python " .. vim.fn.fnameescape(file),
          javascript = "node " .. vim.fn.fnameescape(file),
          typescript = "tsx " .. vim.fn.fnameescape(file),
          rust       = "cargo run",
          sh         = "bash " .. vim.fn.fnameescape(file),
        }
        local cmd = cmds[ft]
        if not cmd then
          vim.notify("Нет раннера для filetype: " .. ft, vim.log.levels.WARN)
          return
        end
        if extra_args and #extra_args > 0 then
          cmd = cmd .. " " .. extra_args
        end
        vim.cmd("OverseerRunCmd " .. vim.fn.shellescape(cmd))
      end

      -- Хоткеи
      vim.keymap.set("n", "<leader>rr", function() run_cmd_for_current_file() end,
        { silent = true, desc = "Run current file" })
      vim.keymap.set("n", "<leader>ra", function()
          local a = vim.fn.input("args: ")
          run_cmd_for_current_file(a)
        end, { silent = true, desc = "Run current file with args" })
      vim.keymap.set("n", "<leader>rR", "<cmd>OverseerRestartLast<cr>",
        { silent = true, desc = "Restart last task" })
      vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>",
        { silent = true, desc = "Task list / output" })
      vim.keymap.set("n", "<leader>rq", "<cmd>OverseerQuickAction<cr>",
        { silent = true, desc = "Quick actions (stop/open/…)" })

      -- Опционально: быстрый выбор шаблонов (build/test/npm/make и т.п.)
      vim.keymap.set("n", "<leader>ro", "<cmd>OverseerRun<cr>",
        { silent = true, desc = "Run template" })
    end
  },
}

