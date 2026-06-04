-- General
vim.cmd.language("en_US.UTF-8")

-- Disable unused remote-host providers (the asdf python/ruby paths no longer
-- exist; nothing here needs a remote host, so silence :checkhealth and skip
-- the startup probe of missing interpreters).
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable unused built-in runtime plugins (netrw is replaced by oil; the
-- archive/tutor/tohtml/rplugin ones are unused here). Keep matchit/matchparen
-- (% pairs), man (:Man), and shada (marks/registers/history).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_remote_plugins = 1

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
vim.opt.showtabline = 0
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.visualbell = false
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.wrap = true
vim.opt.cmdheight = 0
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
vim.opt.autoread = true
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
