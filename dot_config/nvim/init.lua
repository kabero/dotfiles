-- disable some standard plugins
-----------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load configs
-----------------------------
require "options"
require "color"
require "keymap"
require "plugins"
require "lsp"

-- configs of plugins
-----------------------------
local opts = { noremap = true, silent = true }
require("nvim-tree").setup()
require("gitsigns").setup()

-- nvim-tree
vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", opts)


-- whichkey
vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", opts)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


-- other configs
-----------------------------

-- open a quickfix window when executing a command whose name contains "grep"
vim.cmd([[autocmd QuickFixCmdPost *grep* cwindow]])
