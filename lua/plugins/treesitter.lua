return {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "gosum", "lua", "python", "rust", "bash", "json", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
}

