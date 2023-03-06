local opt = vim.opt
local cmd = vim.cmd

-- General
cmd("language C")
cmd("set encoding=utf-8")
opt.clipboard:append { 'unnamedplus' }
opt.mouse = 'a'
opt.fileformats = 'unix', 'mac', 'dos'

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true
opt.wrapscan = true

-- View
opt.cursorline = false
opt.number = true
opt.numberwidth = 4
opt.ruler = true
opt.showmatch = true
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.visualbell = false
opt.wildmenu = true
opt.wrap = true

-- Edit
opt.autoindent = true
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4

-- Others
opt.swapfile = false
opt.updatetime = 300

-- Window
opt.splitbelow = true
opt.splitright = true

-- Avoid automatically commenting when adding a new line
cmd [[ autocmd FileType * setlocal formatoptions-=r ]]
cmd [[ autocmd FileType * setlocal formatoptions-=o ]]
