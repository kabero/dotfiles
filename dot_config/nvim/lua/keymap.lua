local opts = { noremap = true, silent = true }

-- helper
------------------------------------
GetChezmoiDir = function()
    local handle = io.popen("chezmoi source-path")
    if handle ~= nil then
        local result = handle:read('*a')
        handle:close()
        local chezmoi_dir = result:gsub("\n$", "")
        return chezmoi_dir
    end
    return nil
end

GetNVimConfigPath = function()
    local chezmoi_dir = GetChezmoiDir()
    if chezmoi_dir ~= nil then
        return chezmoi_dir .. "/dot_config/nvim/init.lua"
    end
    return nil
end

-- General
------------------------------------
vim.g.mapleader = " "

-- Normal
------------------------------------
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "]b", ":<c-u>bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[b", ":<c-u>bprev<CR>", opts)
vim.api.nvim_set_keymap("n", "]q", ":<c-u>cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[q", ":<c-u>cprev<CR>", opts)
vim.api.nvim_set_keymap("n", "<c-l>", ":<c-u>noh<CR><c-l>", opts)
vim.api.nvim_set_keymap("n", "<c-o>", "<c-o>zz", opts)
vim.api.nvim_set_keymap("n", "<c-i>", "<c-i>zz", opts)

-- open init.vim in chezmoi dir
vim.api.nvim_set_keymap("n", "<leader>,",
    ":execute 'edit ' .. luaeval('GetNVimConfigPath()')<CR> :execute 'lcd ' .. luaeval('GetChezmoiDir()')<CR>", opts)

-- Insert
------------------------------------

-- Visual
------------------------------------

-- Command
------------------------------------
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-h>", "<BS>", { noremap = true })
-- FIXME: The behavior when the cursor is a the beginning of a line
vim.api.nvim_set_keymap("c", "<C-k>", "<C-f>D<C-c><C-c>:<Up>", { noremap = true })

-- Terminal
------------------------------------
vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
    tnoremap <c-[> <C-\><C-n>
]]
