return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        style = "#806d9c",
        -- require to apply scripting language like Python (true by default). 
        -- use_treesitter = false,
        chars = {
          left_top = "┌",
          left_bottom = "└",
        },
        exclude_filetypes = {
          aerial = true,
          dashboard = true,
        },
      },
      indent = {
        enable = true,
        priority = 10,
        style = {
          { fg = "#3c4048" },
        },
        use_treesitter = false,
        chars = { "│" },
        ahead_lines = 5,
        delay = 100,
      }
    })
  end
}
