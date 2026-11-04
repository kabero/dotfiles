local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'One Half Black (Gogh)'

config.window_decorations = "RESIZE"
-- Keep Herdr's tabs and place a slim WezTerm control bar beneath them.
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = true
config.tab_bar_style = {
  new_tab = wezterm.format { { Text = ' ◐ MENU ' } },
  new_tab_hover = wezterm.format { { Text = ' ◐ MENU ' } },
}
config.font = wezterm.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'Light' },
    'Hiragino Maru Gothic ProN'
}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.use_ime = true
config.font_size = 13.0
config.term = "xterm-256color"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.default_cursor_style = 'SteadyBar'

local function toggle_opacity(window)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end

local window_control = wezterm.action_callback(function(window, pane, id, _)
  if id == 'opacity' then
    toggle_opacity(window)
  elseif id == 'pin' then
    window:perform_action(wezterm.action.ToggleAlwaysOnTop, pane)
  end
end)

wezterm.on('new-tab-button-click', function(window, pane, button)
  if button ~= 'Left' then
    return false
  end
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity or config.window_background_opacity
  local next_opacity = opacity == 1.0 and config.window_background_opacity or 1.0
  window:perform_action(wezterm.action.InputSelector {
    title = 'Terminal menu',
    choices = {
      {
        id = 'opacity',
        label = string.format('BG  %d%% → %d%%',
          math.floor(opacity * 100 + 0.5),
          math.floor(next_opacity * 100 + 0.5)),
      },
      { id = 'pin', label = 'PIN  最前面に固定 / 解除' },
    },
    action = window_control,
  }, pane)
  return false
end)

wezterm.on('update-status', function(window, _)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity or config.window_background_opacity
  window:set_right_status(string.format(' BG %d%% ', opacity * 100))
end)

config.colors = {
  cursor_bg = '#b08ae6',
  cursor_border = '#b08ae6',
  selection_bg = '#2b2038',
  tab_bar = {
    background = '#0b0912',
    new_tab = { bg_color = '#241c32', fg_color = '#b08ae6' },
    new_tab_hover = { bg_color = '#352447', fg_color = '#f8f8f2' },
  },
}

config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 6,
}

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
  -- The script itself picks the venue: tmux popup when a tmux client is
  -- attached, a native herdr popup otherwise. Calling it directly (not
  -- via `tmux run-shell`) keeps it working when no tmux server is running.
  wezterm.background_child_process {
    wezterm.home_dir .. '/.local/bin/tmux-open-file', '--token', target,
  }
  return false -- suppress "open in browser"
end)

return config
