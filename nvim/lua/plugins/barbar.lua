return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- optional: for git status
    'nvim-tree/nvim-web-devicons', -- optional: for file icons
  },
  init = function() 
    vim.g.barbar_auto_setup = false 
  end,
  config = function()
    require('barbar').setup({
      -- Enable/disable animations
      animation = true,
      
      -- Enable/disable auto-hiding the tab line when there is a single buffer
      auto_hide = false,
      
      -- Enable/disable current/total tabpages indicator (top right corner)
      tabpages = true,
      
      -- Enables/disable clickable tabs
      clickable = true,
      
      -- Excludes buffers from the tabline
      exclude_ft = {'javascript'},
      exclude_name = {'package.json'},
      
      -- 無名バッファの処理を改善
      closable = true,
      
      -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
      focus_on_close = 'left',
      
      -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
      hide = {extensions = true, inactive = false},
      
      -- Disable highlighting alternate buffers
      highlight_alternate = false,
      
      -- Disable highlighting file icons in inactive buffers
      highlight_inactive_file_icons = false,
      
      -- Enable highlighting visible buffers
      highlight_visible = true,
      
      icons = {
        -- Configure the base icons on the bufferline.
        buffer_index = false,
        buffer_number = false,
        button = '',
        -- Enables / disables diagnostic symbols
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
          [vim.diagnostic.severity.WARN] = {enabled = false},
          [vim.diagnostic.severity.INFO] = {enabled = false},
          [vim.diagnostic.severity.HINT] = {enabled = true},
        },
        gitsigns = {
          added = {enabled = true, icon = '+'},
          changed = {enabled = true, icon = '~'},
          deleted = {enabled = true, icon = '-'},
        },
        filetype = {
          -- Sets the icon's highlight group.
          -- If false, will use nvim-web-devicons colors
          custom_colors = false,
          -- Requires `nvim-web-devicons`
          enabled = true,
        },
        separator = {left = '▎', right = ''},
        -- Configure the icons on the bufferline based on the visibility of a buffer.
        -- If true, it uses the default highlighting groups.
        -- If a string, it uses that highlight group.
        -- If a function, it uses the result of that function.
        -- If an object, it uses the `fg` and `bg` keys.
        inactive = {button = '×'},
        pinned = {button = '', filename = true},
      },
      
      -- If true, new buffers will be inserted at the start/end of the list.
      insert_at_end = false,
      insert_at_start = false,
      
      -- Sets the maximum padding width with which to surround each tab
      maximum_padding = 1,
      
      -- Sets the minimum padding width with which to surround each tab
      minimum_padding = 1,
      
      -- Sets the maximum buffer name length.
      maximum_length = 30,
      
      -- Sets the minimum buffer name length.
      minimum_length = 0,
      
      -- If set, the letters for each buffer in buffer-pick mode will be
      -- assigned based on their name. Otherwise or in case all letters are
      -- already assigned, the behavior is to assign letters in order of
      -- usability (see order below)
      semantic_letters = true,
      
      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = true,
        -- Or, specify the text used for the offset:
        undotree = {text = 'undotree'},
        -- Or, specify the event which the sidebar executes when leaving:
        ['neo-tree'] = {event = 'BufWipeout'},
        -- Or, specify both
        Outline = {event = 'BufWinLeave', text = 'symbols-outline'},
      },
      
      -- New buffer letters are assigned in this order. This order is
      -- optimal for the qwerty keyboard layout but might need adjustment
      -- for other layouts.
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      
      -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
      -- where X is the buffer number. But only a static string is accepted here.
      no_name_title = "[No Name]",
    })
  end,
  -- NordFoxテーマ適用後に色設定を行う
  event = "VeryLazy",
  priority = 1000,
  version = '^1.0.0',
}
