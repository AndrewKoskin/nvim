return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lualine/lualine.nvim", event = "VeryLazy",
    config = function() require("lualine").setup({ options = { theme = "auto" } }) end
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function() vim.cmd.colorscheme("catppuccin-mocha") end
  },
}

