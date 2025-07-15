return {
  {
    "neovim/nvim-lspconfig",
    opt = {},
  },
  {
    "mason-org/mason.nvim",
    opt = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opt = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
