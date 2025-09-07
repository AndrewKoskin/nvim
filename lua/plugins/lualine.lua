return {
  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      local navic = require("nvim-navic")

      require("lualine").setup {
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { 
            { navic.get_location, cond = navic.is_available } 
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}

