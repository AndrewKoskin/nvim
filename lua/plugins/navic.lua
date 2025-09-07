-- ~/.config/nvim/lua/plugins.lua или ~/.config/nvim/lua/plugins/init.lua
-- return require("lazy").setup({
--     -- другие плагины
--     {
--         "SmiteshP/nvim-navic",
--         dependencies = "neovim/nvim-lspconfig",
--         config = function()
--             require("nvim-navic").setup {
--                 highlight = true,
--                 separator = " > ",
--             }
--         end,
--     },
-- })
--
return{
  { 
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup {
        highlight = true,
        separator = " > ",
      }
    end,
  },
}
