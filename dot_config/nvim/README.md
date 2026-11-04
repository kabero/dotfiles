# neovim configuration

Neovim **0.11+** 用の個人設定。[lazy.nvim](https://github.com/folke/lazy.nvim) によるモジュール構成で、[chezmoi](https://www.chezmoi.io/) で管理している。

> **chezmoi メモ**: このディレクトリは chezmoi の *ソース*（`~/.local/share/chezmoi/dot_config/nvim`）。実体の `~/.config/nvim` は symlink ではなく**コピー**なので、編集を反映するには `chezmoi apply ~/.config/nvim` が必要。`nvim -u <source>/init.lua` でもプラグイン spec は rtp 経由で*適用済みコピー*から読まれる点に注意（apply してからテストすること）。

---

## ファイル構成

```
init.lua                  -- bootstrap と各モジュールの読み込み
lua/
  options.lua             -- vim.opt 全般・プロバイダ/組込プラグイン無効化
  keymap.lua              -- 素の(プラグイン非依存)キーマップ
  filetype.lua            -- chezmoi/.tmpl/env 等のファイルタイプ判定
  autocmds.lua            -- yank・カーソル復元・端末などの自動コマンド
  run.lua                 -- :Run / <leader>q とプロジェクトの RunTasks
  x_palette.lua           -- :X / <leader>x のコマンドパレット
  colors.lua              -- colorscheme 指定 + ハイライト上書き
  plugins/
    lsp.lua               -- mason / lspconfig / lspsaga / conform
    -- 整形は conform.nvim。グローバルで formatter を固定せず、各プロジェクトの
    -- exrc(.nvim.lua)で require("conform").formatters_by_ft.<ft> = {...} で登録する。
    completion.lua        -- blink.cmp
    snacks.lua            -- picker / notifier / 各種 QoL
    treesitter.lua        -- treesitter + textobjects
    git.lua               -- gitsigns / fugitive / diffview / git-conflict / committia
    editor.lua            -- autopairs / surround / commentary 等
    tools.lua             -- oil / copilot / rustowl / sensei 等
    -- sensei.nvim はグローバルでは language=Japanese だけを既定にし、subject と
    -- build driver は各プロジェクトの exrc(.nvim.lua)で require("sensei").setup{...}。
    -- この require がプラグインのロード契機も兼ねる（サイドカーは未ロードだと繋がらない）。
    ui.lua                -- lualine / incline / rainbow-delimiters / colorizer 等
    colorscheme.lua       -- kanagawa
```

---

## 特徴的な構成

採用しているプラグインの全一覧は [`PLUGINS.md`](./PLUGINS.md)。ここは方針だけ。

| 領域 | 採用 | 備考 |
|---|---|---|
| プラグイン管理 | **lazy.nvim** | `lua/plugins/*` を自動 import |
| カラースキーム | **kanagawa (dragon)** | italic 無効・gutter 透過 |
| ステータス/UI | **lualine** + **incline**(winbar) | `laststatus=3` グローバル, `cmdheight=0`, `showtabline=0` |
| ピッカー | **snacks.nvim** | files/grep/git/lsp。dashboard は無効 |
| 補完 | **blink.cmp** | LSP capabilities をサーバへ broadcast 済み。署名ヘルプも本体機能 |
| AI 補完 | **copilot.vim**(ghost text) | `<C-l>` で確定。秘匿情報のファイルタイプ／パスでは自動オフ |
| LSP | **mason** + **mason-lspconfig**(`automatic_enable`) | UI に lspsaga、通知は snacks.notifier |
| 構文 | **nvim-treesitter** + **textobjects** | 両者とも `master` ブランチ（クラシック API）で固定 |
| Git | **gitsigns** / **fugitive** / **diffview** / **committia** | レビュー特化（後述）。コミット/ステージはターミナル運用 |
| ファイラ | **oil.nvim** | netrw は無効化、`-` で親ディレクトリ |
| Markdown | **render-markdown.nvim** | バッファ内インラインレンダリング、`<leader>q` でトグル |
| 学習支援 | **sensei.nvim** | Claude Code をサイドカーにした MCP サーバ。答えは書かず、buffer/診断/ビルド結果を見てヒントだけ出す。プロジェクトごとに `:SenseiInstall` |

### 起動高速化・セキュリティ
- 未使用の**リモートホストプロバイダ**（python/ruby/perl/node）と**組込みプラグイン**（netrw, gzip, tar, zip, tutor, 2html …）を無効化。
- **Copilot を秘匿情報で自動オフ**：`.env`/`.ssh`/`.aws`/`.kube`/`*.pem`/`*.key`/`*.tfstate`/`*.tfvars`/`id_rsa` 等のパス（`BufEnter` で判定）、および `markdown`/`terraform`/`sshconfig`/`dosini`/`sql`/`gitcommit` 等のファイルタイプ。
- **chezmoi 連携のファイルタイプ判定**：`dot_*` ソースを実ファイル名にマップして判定。`*.tmpl` は元拡張子で解決（`dot_zshrc.tmpl` → `zsh`）。

### 基本オプション（特徴的なもの）
`exrc=true`（プロジェクトローカル rc）・`undofile`・`noswapfile`・`clipboard=unnamedplus`・`ignorecase`+`smartcase`・`updatetime=250`・`timeoutlen=800`・`signcolumn=yes`・インデントは `expandtab`/`shiftwidth=tabstop=4`（C は 2）。

---

## キーマップ チートシート

`<leader>` = **Space**

### 移動・基本（プラグイン非依存）
| キー | 動作 |
|---|---|
| `j` / `k` | 表示行で上下移動（`gj`/`gk`）。`gj`/`gk` が論理行 |
| `]b` / `[b` | 次 / 前のバッファ |
| `]q` / `[q` | 次 / 前の quickfix |
| `<C-l>` | 検索ハイライト解除 + 再描画 |
| `<C-s>` | 保存（normal / insert） |
| `<leader>Q` | 確認付き全終了 |
| `<leader>r` | カーソル下の単語を置換 |
| `x`モード `p` | レジスタを汚さず貼り付け |
| cmdline | `<C-a/e/b/f/d/h/k>`・`<M-BS>` で emacs 風編集 |
| terminal | `<Esc>` / `<C-[>` で normal モードへ |

### LSP（lspsaga + snacks picker）
| キー | 動作 |
|---|---|
| `K` | ホバー |
| `gd` / `gD` | 定義 / 宣言へ |
| `gr` / `gi` / `gy` | 参照 / 実装 / 型定義 |
| `gp` | 定義を peek（インライン） |
| `ga` | コードアクション |
| `gR` | リネーム |
| `gl` | フォーマット |
| `ge` | 診断フロート |
| `]g` / `[g` | 次 / 前の診断へ |
| `<leader>0` | アウトライン |
| `<leader>9` | 診断表示トグル |
| `<leader>fi` / `<leader>fo` | 呼び出し階層 incoming / outgoing |

### 補完・AI
| キー | 動作 |
|---|---|
| `<C-n>` / `<C-p>` | 候補を次 / 前へ |
| `<C-f>` / `<CR>` | 確定 |
| **`<Tab>`** | blink.cmp の表示中候補を確定 → スニペット内を移動 → 素の Tab |
| `<C-l>` | Copilot 候補を受理 |
| `<C-c>` | Copilot 候補を破棄 |

### Treesitter テキストオブジェクト
| キー | 対象 |
|---|---|
| `af` / `if` | 関数 outer / inner（例 `vif`, `daf`） |
| `ac` / `ic` | クラス outer / inner |
| `aa` / `ia` | 引数 outer / inner |
| `]m` / `[m` | 次 / 前の関数へ |
| `]]` / `[[` | 次 / 前のクラスへ |

### 検索（snacks picker, `<leader>f`）
| キー | 動作 |
|---|---|
| `<leader>fj` | ファイル検索 |
| `<leader>fh` / `<leader>fH` | スマート最近 / 最近開いた |
| `<leader>fk` | grep |
| `<leader>fl` | カーソル単語/選択を grep |
| `<leader>fb` | バッファ一覧 |
| `<leader>fn` | ファイルブラウザ |

### Git
コミット・ステージはターミナルで行い、**Vim 内は「高速レビュー」に特化**している。

| キー | 動作 |
|---|---|
| `<leader>gs` | git status ピッカー |
| `<leader>gl` | git log（行単位） |
| `<leader>gv` | git grep |
| `<leader>gd` | master/main 比較 diff（フラットなファイル一覧） |
| `<leader>gc` | 現在ファイルの git log（fugitive） |
| **`<leader>d`** | **diffview: 作業ツリー diff をトグル** |
| **`<leader>D`** | **diffview: ブランチ vs master（merge-base = PR レビュー）** |
| **`<leader>gh`** | **diffview: 現在ファイルの履歴** |
| **`<leader>gH`** | **diffview: リポジトリ履歴** |
| diffview 内 `q` | リスト/履歴パネルからクローズ（差分窓では `q` はマクロ記録のまま温存） |

#### Git ハンク（gitsigns, `<leader>a` グループ）
| キー | 動作 |
|---|---|
| `]c` / `[c` | 次 / 前のハンクへ |
| `<leader>aj` | ハンクをプレビュー |
| `<leader>ak` | 行 blame（full） |
| `<leader>al` | このファイルを縦 diff |
| `<leader>1` | 行 blame 表示トグル |
| `<leader>2` | 削除行表示トグル |

### その他ツール
| キー | 動作 |
|---|---|
| `-` | oil で親ディレクトリを開く |
| `go` | URL を開く / 単語や選択範囲を Web 検索 |
| `<leader>q` | `:Run` でファイルを実行（Markdown では表示トグル） |
| `<leader>x` | プロジェクトごとのコマンドパレット `:X` |
| `<leader>o` | RustOwl トグル（rust） |

### ノート（notemode.nvim）
| キー | 動作 |
|---|---|
| `<leader>m` | ノートモードの開閉（どこからでも） |
| `gf` | 行に書いたノート名へ飛ぶ（無ければ新規。ノートバッファ内のみ） |

### ユーザーコマンド
| コマンド | 動作 |
|---|---|
| `:Note` | `kabe/notes/` の最新インデックスのノートを開く |
| `:Note new` | 次番号のノートを作成 |
| `:Note <name>` | `kabe/notes/<name>.md` を開く |
| `:SenseiInstall` | そのプロジェクトを sensei 用にセットアップ（`.mcp.json` / `CLAUDE.md` / `.claude/`） |
| `:Sensei` / `:SenseiStatus` | セットアップ状況・socket・登録ツールの確認 |
| `:SenseiClearHints` | 画面上のヒント(virtual text)を消す |
| `:Run [task]` | ファイルタイプ別の実行、または `.nvim.lua` の `RunTasks` を実行 |
| `:X` | プロジェクトごとのシェルコマンドを編集・実行 |

---

## 設計メモ

- **muscle memory を最優先**：既存の lhs を奪う変更はしない。新機能は空きキーに乗せる。
- **既存資産の活用優先**：新規プラグインは最小限。インストール済みで未活用のもの（diffview 等）をまず使い切る。
- **`<Tab>` の単一所有者**：blink.cmp の候補確定とスニペット移動を `completion.lua` のハンドラに集約。
- **treesitter は `master` で統一**：本体・textobjects とも旧 API。`main`（リライト版）とは混在不可。
