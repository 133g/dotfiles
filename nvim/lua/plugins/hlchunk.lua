return {
  "shellRaining/hlchunk.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
      },
      indent = {
        enable = true,
      }
    })
  end
}
