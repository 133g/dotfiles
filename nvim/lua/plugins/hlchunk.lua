return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        notify = false,
        priority = 15,
        style = {
          { fg = "#806d9c" },
        },
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",  
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
        exclude_filetypes = {
          aerial = true,
          dashboard = true,
        },
        delay = 0,
        duration = 50,
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
