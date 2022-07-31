require 'options'
require 'plugins'
require 'keymaps'
require 'commands'
require 'color'

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
        disable = {
        }
    }
}

-- Run PackerCompile when plugins.lua is edited
vim.cmd[[autocmd BufWritePost plugins.lua PackerCompile]]

