# プラグイン一覧

`lua/plugins/*.lua` に置いてある [lazy.nvim](https://github.com/folke/lazy.nvim) の spec を、
ファイルごとにまとめたもの。設計の意図や使い分けは [`README.md`](./README.md) の
「特徴的な構成」、キーの割り当ては同「キーマップ チートシート」を参照。

「読み込み」はその spec の lazy.nvim 側の契機（`event` / `ft` / `cmd` / `keys`）。

---

## colorscheme.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | カラースキーム。`dragon` 固定、italic 無効、gutter 背景は透過 | 起動時 (`lazy = false`) |

## completion.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [blink.cmp](https://github.com/saghen/blink.cmp) | 補完。nvim-cmp + source 群を置き換えたもの。スニペット展開は組込みの `vim.snippet`、署名ヘルプも本体の `signature` 機能で賄う（lsp_signature.nvim は不要） | `InsertEnter` / `CmdlineEnter` |

## lsp.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP サーバ等のインストーラ | `VeryLazy` |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | mason と lspconfig の橋渡し。`automatic_enable` で自動有効化し、blink.cmp の capabilities を全サーバへ broadcast | `VeryLazy` |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | サーバ定義集（mason-lspconfig の依存） | 同上 |
| [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) | LSP の UI（hover / code action / rename / winbar シンボル） | `LspAttach` |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | フォーマッタ。グローバルでは formatter を固定せず、各プロジェクトの exrc (`.nvim.lua`) で `formatters_by_ft` に登録する。`gl` で実行 | `BufReadPre` / `BufNewFile`, `:ConformInfo` `:Format` |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | conform が呼ぶバイナリを用意する（stylua / prettierd / shfmt / ruff） | `VeryLazy` |

## snacks.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | ピッカー（files / grep / git / lsp）と QoL 詰め合わせ。有効にしているのは `bigfile` `input` `picker` `notifier` `quickfile` `scope` `scroll` `statuscolumn` `words` `zen`。`dashboard` `explorer` `indent` は無効 | 起動時 (`lazy = false`) |

## treesitter.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 構文解析・ハイライト・インデント。`master` ブランチ固定（`main` は非互換の書き直し） | `BufReadPost` / `BufNewFile` |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | `af`/`if`/`ac`/`ic`/`aa`/`ia` と `]m`/`[m`/`]]`/`[[`。こちらも `master` 固定 | 同上（依存） |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | HTML/JSX タグの自動閉じ | 同上（依存） |
| [tree-sitter-blade](https://github.com/EmranMR/tree-sitter-blade) | Blade (`*.blade.php`) のパーサ登録 | `ft = blade` |

## git.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | 差分サイン、ハンク移動 `]c`/`[c`、`<leader>a` グループのプレビュー/blame/diff | `BufReadPost` / `BufNewFile` |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | `:Git` 系。`<leader>gc` でファイルの git log | `:Git` ほか, `<leader>gc` |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | 差分・ファイル履歴のレビュー用ビュー | `:Diffview*` |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | コンフリクト領域の色分けと解決。ours=緑 / theirs=青 / base=赤 で diff の配色に合わせている。既定マップは切って buffer ローカルに配線 | `BufReadPost` / `BufNewFile` |
| [committia.vim](https://github.com/rhysd/committia.vim) | コミットメッセージ編集画面（差分とステータスを並べる） | `ft = gitcommit` |

コミット / ステージはターミナル運用で、Neovim 側はレビューに寄せている。

## editor.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 括弧・クォートの自動補完 | `InsertEnter` |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | 囲み文字の追加/変更/削除 | `VeryLazy` |
| [vim-endwise](https://github.com/tpope/vim-endwise) | `end` / `endif` 等の自動補完 | `VeryLazy` |
| [vim-sleuth](https://github.com/tpope/vim-sleuth) | インデント設定をファイルから推定 | `BufReadPost` |
| [hop.nvim](https://github.com/phaazon/hop.nvim) | `<leader>s` で単語ホップ | `VeryLazy` |
| [rainbow_csv](https://github.com/mechatroner/rainbow_csv) | CSV の列ごとの色分け | `ft = csv` |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown のバッファ内インラインレンダリング。既定オフ、`<leader>q` でトグル | `ft = markdown` |

## tools.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [oil.nvim](https://github.com/stevearc/oil.nvim) | ファイラ。`-` で親ディレクトリ。netrw は無効化済み。ディレクトリバッファを乗っ取る必要があるため遅延読み込みしない | 起動時 (`lazy = false`) |
| [copilot.vim](https://github.com/github/copilot.vim) | AI 補完（ghost text）。`<C-l>` で確定、`<C-c>` で却下。秘匿情報のファイルタイプ／パスでは自動オフ | `InsertEnter` |
| [rustowl](https://github.com/cordx56/rustowl) | Rust の所有権・ライフタイム可視化。`<leader>o` でトグル | `ft = rust` |
| [sensei.nvim](https://github.com/kabero/sensei.nvim) | Claude Code をサイドカーにした MCP サーバ。答えは書かずヒントだけ出す。言語は既定で日本語、subject と build driver はプロジェクトの exrc で設定し、その `require` がロード契機も兼ねる | `:Sensei*` |
| [notemode.nvim](https://github.com/kabero/notemode.nvim) | ノートモード（`:Note`）。ghq の clone があればそれを読み込み、無ければ GitHub から取得 | `:Note`, `ft = markdown` |

## ui.lua

| プラグイン | 用途 | 読み込み |
|---|---|---|
| [mini.icons](https://github.com/nvim-mini/mini.icons) | アイコン供給元を一本化。nvim-web-devicons をモックするので、それを `require` する側（incline）もそのまま動く | 遅延 (`lazy = true`) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン（`laststatus=3` のグローバル表示） | `VeryLazy` |
| [incline.nvim](https://github.com/b0o/incline.nvim) | winbar のファイル名表示。カーソルが画面上部 5 行以内なら出さない | `VeryLazy` |
| [rainbow-delimiters.nvim](https://github.com/hiphish/rainbow-delimiters.nvim) | 括弧の対応を色分け。`<leader>7` でトグル | `VeryLazy` |
| [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) | カラーコードをその色で表示 | `ft = css/scss/html/javascript/typescript/blade` |
