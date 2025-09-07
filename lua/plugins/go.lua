return {
  -- Форматирование (безопасный менеджер форматтеров)
  { "stevearc/conform.nvim", event = "BufReadPre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go = { "gofumpt", "goimports" },
        },
      })
      -- форматировать Go при сохранении
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function() require("conform").format({ async = false }) end,
      })
    end
  },

  -- Линтинг
  { "mfussenegger/nvim-lint", event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { go = { "golangcilint" } }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        pattern = "*.go",
        callback = function() lint.try_lint() end,
      })
    end
  },

  -- Go LSP (gopls) + keymaps
  { "neovim/nvim-lspconfig", ft = "go",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            hints = { assignVariableTypes = true, parameterNames = true, rangeVariableTypes = true },
          },
        },
        on_attach = function(_, bufnr)
          local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true }) end
          map("n", "gd", vim.lsp.buf.definition)
          map("n", "gr", vim.lsp.buf.references)
          map("n", "K",  vim.lsp.buf.hover)
          map("n", "<leader>rn", vim.lsp.buf.rename)
          map("n", "<leader>ca", vim.lsp.buf.code_action)
          map("n", "<leader>f", function() require("conform").format({ async = true }) end)
        end,
      })
    end
  },

  -- Тесты: neotest + neotest-go
  { "nvim-neotest/neotest", ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
	  "nvim-neotest/nvim-nio", -- Тут я поменял, добавил nvim-nio
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-go")({
            experimental = { test_table = true },
            args = { "-count=1", "-timeout=60s" },
          })
        }
      })
      -- горячие клавиши под Go тесты
      vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { silent = true })
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { silent = true })
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { silent = true })
      vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { silent = true })
    end
  },

  -- Дебаг Go через Delve
  -- { "mfussenegger/nvim-dap", event = "VeryLazy" },
  -- { "leoluz/nvim-dap-go", ft = "go",
  --   config = function()
  --     require("dap-go").setup()
  --     -- пример биндингов
  --     local dap = require("dap")
  --     vim.keymap.set("n", "<F9>", dap.continue, { silent = true })
  --     vim.keymap.set("n", "<F8>", dap.step_over, { silent = true })
  --     vim.keymap.set("n", "<F7>", dap.step_into, { silent = true })
  --     vim.keymap.set("n", "<F12>", dap.step_out, { silent = true })
  --     vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { silent = true })
  --   end
  -- },
  -- Дебаг Go через Delve + UI + inline
	{ "mfussenegger/nvim-dap", event = "VeryLazy" },

	{ "rcarriga/nvim-dap-ui",
	  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	  config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		-- авто-панели при старте/завершении
		dap.listeners.before.attach.dapui = function() dapui.open() end
		dap.listeners.before.launch.dapui = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui = function() dapui.close() end
		dap.listeners.before.event_exited.dapui = function() dapui.close() end
		-- хоткеи UI
		vim.keymap.set("n", "<leader>du", dapui.toggle, { silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>de", function() dapui.eval() end, { silent = true })
		-- быстрые флоттеры
		vim.keymap.set("n", "<leader>df", function() dapui.float_element("scopes", { enter = true }) end, { silent = true })
		vim.keymap.set("n", "<leader>dr", function() dapui.float_element("repl",   { enter = true }) end, { silent = true })

	  end
	},

	{ "theHamsta/nvim-dap-virtual-text",
	  config = function()
		require("nvim-dap-virtual-text").setup({
		  commented = true,
		  virt_text_pos = "inline",                 -- Neovim 0.10+
		  highlight_changed_variables = true,
		  show_stop_reason = true,
		})
	  end
	},

	{ "leoluz/nvim-dap-go", ft = "go",
	  dependencies = { "mfussenegger/nvim-dap" },
	  config = function()
		require("dap-go").setup()
		local dap = require("dap")
		-- базовые хоткеи
		vim.keymap.set("n", "<F2>",  dap.continue,      { silent = true })
		vim.keymap.set("n", "<F3>",  dap.step_over,     { silent = true })
		vim.keymap.set("n", "<F4>",  dap.step_into,     { silent = true })
		vim.keymap.set("n", "<F5>", dap.step_out,      { silent = true })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { silent = true })
	  end
	},

}

