require 'options'
require 'plugins'
require 'keymaps'
require 'commands'
require 'color'

-- Run PackerCompile when plugins.lua is edited
vim.cmd[[autocmd BufWritePost plugins.lua PackerCompile]]

