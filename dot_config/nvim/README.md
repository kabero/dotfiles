# neovim configuration

Neovim **0.11+** 用の個人設定。[lazy.nvim](https://github.com/folke/lazy.nvim) によるモジュール構成で、[chezmoi](https://www.chezmoi.io/) で管理している。

> **chezmoi メモ**: このディレクトリは chezmoi の *ソース*（`~/.local/share/chezmoi/dot_config/nvim`）。実体の `~/.config/nvim` は symlink ではなく**コピー**なので、編集を反映するには `chezmoi apply ~/.config/nvim` が必要。`nvim -u <source>/init.lua` でもプラグイン spec は rtp 経由で*適用済みコピー*から読まれる点に注意（apply してからテストすること）。

---

## ファイル構成

```
init.lua                  -- bootstrap・autocmd・ユーザーコマンド(:Note 等)
lua/
  options.lua             -- vim.opt 全般・プロバイダ/組込プラグイン無効化
  keymap.lua              -- 素の(プラグイン非依存)キーマップ
  filetype.lua            -- chezmoi/.tmpl/env 等のファイルタイプ判定
  colors.lua              -- colorscheme 指定 + ハイライト上書き
  plugins/
    lsp.lua               -- mason / lspconfig / lspsaga / none-ls / fidget
    completion.lua        -- nvim-cmp
    snacks.lua            -- picker / dashboard / 各種 QoL
    treesitter.lua        -- treesitter + textobjects
    git.lua               -- gitsigns / fugitive / diffview / committia
    editor.lua            -- autopairs / surround / commentary / hop 等
    tools.lua             -- oil / copilot / sidekick / jaq / rustowl 等
    ui.lua                -- lualine / incline / which-key / colorizer 等
    colorscheme.lua       -- kanagawa
```

---

## 特徴的な構成

| 領域 | 採用 | 備考 |
|---|---|---|
| プラグイン管理 | **lazy.nvim** | `lua/plugins/*` を自動 import |
| カラースキーム | **kanagawa (dragon)** | italic 無効・gutter 透過 |
| ステータス/UI | **lualine** + **incline**(winbar) | `laststatus=3` グローバル, `cmdheight=0`, `showtabline=0` |
| ピッカー | **snacks.nvim** | files/grep/git/lsp、dashboard で `gh pr/issue` 表示 |
| 補完 | **nvim-cmp** | LSP capabilities をサーバへ broadcast 済み |
| AI 補完 | **copilot.vim**(ghost text) + **sidekick.nvim**(NES) | 役割分担：補完は copilot、*次の編集予測*は sidekick |
| LSP | **mason** + **mason-lspconfig**(`automatic_enable`) | UI に lspsaga、進捗に fidget、署名に lsp_signature |
| 構文 | **nvim-treesitter** + **textobjects** | 両者とも `master` ブランチ（クラシック API）で固定 |
| Git | **gitsigns** / **fugitive** / **diffview** / **committia** | レビュー特化（後述）。コミット/ステージはターミナル運用 |
| ファイラ | **oil.nvim** | netrw は無効化、`-` で親ディレクトリ |
| 移動 | **hop.nvim** | `<leader>s` で単語ホップ |
| Markdown | **render-markdown.nvim** | バッファ内インラインレンダリング、`<leader>q` でトグル |

### 起動高速化・セキュリティ
- 未使用の**リモートホストプロバイダ**（python/ruby/perl/node）と**組込みプラグイン**（netrw, gzip, tar, zip, tutor, 2html …）を無効化。
- **Copilot を秘匿情報で自動オフ**：`.env`/`.ssh`/`.aws`/`.kube`/`*.pem`/`*.key`/`*.tfstate`/`*.tfvars`/`id_rsa` 等のパス（`BufEnter` で判定）、および `markdown`/`terraform`/`sshconfig`/`dosini`/`sql`/`gitcommit` 等のファイルタイプ。
- **chezmoi 連携のファイルタイプ判定**：`dot_*` ソースを実ファイル名にマップして判定。`*.tmpl` は元拡張子で解決（`dot_zshrc.tmpl` → `zsh`）。

### 基本オプション（特徴的なもの）
`exrc=true`（プロジェクトローカル rc）・`undofile`・`noswapfile`・`clipboard=unnamedplus`・`ignorecase`+`smartcase`・`updatetime=250`・`timeoutlen=300`・`signcolumn=yes`・インデントは `expandtab`/`shiftwidth=tabstop=4`（C は 2）。

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
| **`<Tab>`** | **統合ハンドラ**: NES適用 → ネイティブ inline補完 → cmp確定 → 素の Tab |
| `<C-l>` | Copilot 候補を受理 |
| `<C-c>` | Copilot 候補を破棄 |
| `<leader>ac` | sidekick: Claude をトグル |
| `<leader>at` / `<leader>af` / `<leader>av` | sidekick: 選択箇所 / ファイル / ビジュアル選択を送信 |

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
| `<leader>gg` | git grep |
| `<leader>gd` | master/main 比較 diff（フラットなファイル一覧） |
| `<leader>gc` | 現在ファイルの git log（fugitive） |
| **`<leader>gv`** | **diffview: 作業ツリー diff をトグル** |
| **`<leader>gV`** | **diffview: ブランチ vs master（merge-base = PR レビュー）** |
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
| `<leader>s` | hop で単語ホップ |
| `go` | open-browser でスマート検索（URL/語） |
| `<leader>q` | jaq でファイルを実行（markdown では render-markdown の表示トグル） |
| `<leader>o` | RustOwl トグル（rust） |

### ユーザーコマンド
| コマンド | 動作 |
|---|---|
| `:Note` | `kabe/notes/` の最新インデックスのノートを開く |
| `:Note new` | 次番号のノートを作成 |
| `:Note <name>` | `kabe/notes/<name>.md` を開く |
| `:HighlightInfo` | カーソル下のハイライトグループを表示 |

---

## 設計メモ

- **muscle memory を最優先**：既存の lhs を奪う変更はしない。新機能は空きキーに乗せる。
- **既存資産の活用優先**：新規プラグインは最小限。インストール済みで未活用のもの（diffview 等）をまず使い切る。
- **`<Tab>` の単一所有者**：補完確定と NES 適用が同キーを奪い合わないよう sidekick 側のハンドラに集約（cmp 側の `<TAB>` は外してある）。
- **treesitter は `master` で統一**：本体・textobjects とも旧 API。`main`（リライト版）とは混在不可。
