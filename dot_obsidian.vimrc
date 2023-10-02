" Reference
" https://github.com/esm7/obsidian-vimrc-support
set clipboard=unnamed

" Use space as leader
unmap <Space>

exmap vs obcommand workspace:split-vertical
exmap sp obcommand workspace:split-horizontal
exmap q obcommand workspace:close
exmap tabnext obcommand workspace:next-tab
exmap tabprev obcommand workspace:previous-tab

exmap toggle_folding obcommand editor:toggle-fold
nmap za :toggle_folding
nmap gt :tabnext
nmap gT :tabprev

nmap <C-l> :noh
exmap source obcommand app:reload
nmap j gj
nmap k gk

" Window navigation
exmap focus_bottom obcommand editor:focus-bottom
exmap focus_left obcommand editor:focus-left
exmap focus_right obcommand editor:focus-right
exmap focus_top obcommand editor:focus-top
nmap <C-w>h :focus_left
nmap <C-w>j :focus_bottom
nmap <C-w>k :focus_top
nmap <C-w>l :focus_right

" rgrep
exmap live_grep obcommand obsidian-another-quick-switcher:grep
nmap <Space>fk :live_grep

" Open files
" exmap open_switcher obcommand switcher:open
" nmap <Space>f :open_switcher

exmap search_file obcommand obsidian-another-quick-switcher:search-command_file-name-fuzzy-search
nmap <Space>fj :search_file

" <leader>w.+
exmap toggle_left_sidebar obcommand app:toggle-left-sidebar
nmap <Space>wh :toggle_left_sidebar
exmap toggle_right_sidebar obcommand app:toggle-right-sidebar
nmap <Space>wl :toggle_right_sidebar

exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

" NOTE: must use 'map' and not 'nmap'
map [[ :surround_wiki
nunmap S
vunmap S
map S" :surround_double_quotes
map S' :surround_single_quotes
map S` :surround_backticks
map Sb :surround_brackets
map S( :surround_brackets
map S) :surround_brackets
map S[ :surround_square_brackets
map S[ :surround_square_brackets
map S{ :surround_curly_brackets
map S} :surround_curly_brackets

" Go difinition
exmap definition obcommand editor:follow-link
nmap gd :definition

" Go back and forward
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward
