return {
  -- LSP + автодополнение + сниппеты
  { "neovim/nvim-lspconfig", event = "BufReadPre" },
  { "hrsh7th/nvim-cmp", event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- автодополнение на enter
          ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- автодополнение на Tab
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end
  },
	 -- nvim-navic для отображения текущего класса/функции
  -- { 
  --   "SmiteshP/nvim-navic",
  --   dependencies = "neovim/nvim-lspconfig",
  --   config = function()
  --     local navic = require("nvim-navic")
  --     navic.setup {
  --       highlight = true,
  --       separator = " > ",
  --     }
  --
  --     -- Пример для gopls (Go), можно добавить другие LSP аналогично
  --     local lspconfig = require("lspconfig")
  --     lspconfig.gopls.setup{
  --       on_attach = function(client, bufnr)
  --         if client.server_capabilities.documentSymbolProvider then
  --           navic.attach(client, bufnr)
  --         end
  --       end,
  --     }
  --   end,
  -- },
}
