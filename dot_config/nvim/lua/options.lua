-- General
vim.cmd("language C")
vim.cmd("set encoding=utf-8")
vim.cmd("let g:python3_host_prog = expand('~/.asdf/installs/python/3.9.1/bin/python')")
vim.cmd("let g:ruby_host_prog = expand('~/.asdf/installs/ruby/3.1.2/bin/ruby')")

vim.opt.ambiwidth = "single"
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.fileformats = 'unix'
vim.opt.mouse = 'a'
vim.o.exrc = true

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- View
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.showtabline = 2
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.visualbell = false
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.wrap = true
vim.cmd([[set fillchars=eob:\ ]])

-- Edit
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.tabstop = 4

-- Others
vim.api.nvim_command('filetype plugin indent on')
vim.opt.compatible = false
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'
vim.opt.undofile = true
vim.opt.updatetime = 250

-- Window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Invisible characters
vim.opt.listchars = "tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲"
