return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require('lualine').setup({
      options = {
        theme = 'nord',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      },
      sections = {
        -- ## Available components
        -- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    })
  end,
}
