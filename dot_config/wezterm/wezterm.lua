local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Kanagawa Dragon (Gogh)'

config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'Light' },
    'Hiragino Maru Gothic ProN'
}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.use_ime = true
config.font_size = 13.0
config.term = "xterm-256color"
config.window_background_opacity = 1.00

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- config.colors = {
--   background = '#100000',
--   compose_cursor = '#2b3261',
-- }

-- File paths become clickable hyperlinks, like URLs. Shift+click one (Shift
-- bypasses tmux mouse reporting, so WezTerm handles the click natively) to
-- open it in nvim inside a tmux popup, via the open-uri hook below.
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- Paths: ~/x, /x, ./x, ../x (single segment ok) or rel/path with ≥2 segments
-- — optional :line[:col]. ASCII classes on purpose: Rust \w is unicode-aware
-- and would glue adjacent Japanese text onto the path.
table.insert(config.hyperlink_rules, {
  regex = [[(?:(?:~|\.{1,2})?/[A-Za-z0-9._@+-]+(?:/[A-Za-z0-9._@+-]+)*|[A-Za-z0-9._@+-]+(?:/[A-Za-z0-9._@+-]+)+)(?::\d+(?::\d+)?)?]],
  format = 'openfile:$0',
})
-- Bare file.ext:line (compiler/grep output without a slash).
table.insert(config.hyperlink_rules, {
  regex = [[\b[A-Za-z0-9._@+-]+\.[A-Za-z][A-Za-z0-9]*:\d+(?::\d+)?\b]],
  format = 'openfile:$0',
})

wezterm.on('open-uri', function(window, pane, uri)
  local target = uri:match('^openfile:(.+)')
  if not target then
    return -- real URLs: default handling (browser)
  end
  wezterm.background_child_process {
    '/opt/homebrew/bin/tmux', 'run-shell', '-b',
    "~/.local/bin/tmux-open-file --token '" .. target .. "'",
  }
  return false -- suppress "open in browser"
end)

return config
