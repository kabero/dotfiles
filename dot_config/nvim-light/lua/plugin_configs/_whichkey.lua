vim.opt.timeout = true
vim.opt.timeoutlen = 800
require("which-key").setup({})
vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", { noremap = true, silent = true })

local wk = require("which-key")
wk.register({
  f = {
    name = "telescope",
    h = "oldfiles",
    j = "find_files",
    k = "live_grep",
    l = "grep_string",
    i = "git_bcommits",
    o = "diagnostics",
    n = "file browser",
  },
  s = "easymotion",
  w = "which-key",
}, { prefix = "<leader>" })

wk.register({
  g = {
    a = "[LSP] code action",
    d = "[LSP] go to definition",
    p = "[LSP] peak definition",
    h = "[LSP] lsp finder",
    D = "[LSP] peek declaration",
    i = "[LSP] go to implementation",
  }
})

wk.register({
  c = {
    name = "call hierarchy",
    i = "incoming calls",
    o = "outgoing calls",
  }
})
