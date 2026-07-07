-- Project tasks for the chezmoi source repo (:Run <name> — see init.lua).
-- `%` expands to the file being edited, i.e. the chezmoi SOURCE path;
-- target-path turns it into the deployed path for scoped apply/diff.
local t = RunTasks

-- Deployed path of the file being edited, or nil + warning for files that
-- are not chezmoi sources (README, this file, ...). target-path alone is
-- not enough: it maps unmanaged paths too, so round-trip via source-path.
local function managed_target()
  local src = vim.fn.expand('%')
  local target = vim.trim(vim.fn.system({ 'chezmoi', 'target-path', src }))
  if vim.v.shell_error == 0 then
    vim.fn.system({ 'chezmoi', 'source-path', target })
  end
  if vim.v.shell_error ~= 0 then
    vim.notify('Run: ' .. src .. ' is not chezmoi-managed', vim.log.levels.WARN)
    return nil
  end
  return target
end

-- Bare :Run / <leader>q — apply just the file being edited. No --force on
-- purpose: "target has changed" conflicts (herdr writes into its own
-- config.toml) should surface, not be clobbered.
t.default = function()
  local target = managed_target()
  if target then vim.cmd('!chezmoi apply ' .. vim.fn.shellescape(target)) end
end

t.diff = function()
  local target = managed_target()
  if target then vim.cmd('!chezmoi diff ' .. vim.fn.shellescape(target)) end
end

t.diffall = 'chezmoi diff'

-- The two edit loops with a step after apply. The lua form avoids "+Lazy!
-- sync" because :! expands a bare ! to the previous shell command.
t.nvim  = [[chezmoi apply ~/.config/nvim && nvim --headless "+lua require('lazy').sync({wait=true, show=false})" +qa]]
t.herdr = 'chezmoi apply ~/.config/herdr/config.toml && herdr server reload-config'
