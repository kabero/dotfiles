# Project-local Neovim Configuration Examples

このディレクトリには、プロジェクト固有のNeovim設定ファイル（`.nvim.lua`）のテンプレートが含まれています。

## 概要

Neovimの`exrc`機能を使用することで、プロジェクトごとに異なる設定（LSP、フォーマッター、キーマップなど）を適用できます。

## 使い方

### 1. テンプレートをコピー

```bash
# プロジェクトルートで実行
cp ~/.local/share/chezmoi/examples/.nvim.lua.template .nvim.lua
```

### 2. 設定をカスタマイズ

`.nvim.lua`を編集して、プロジェクトに合わせた設定に変更します。

### 3. Neovimで開く

```bash
cd /path/to/your/project
nvim .
```

初回ロード時に信頼確認プロンプトが表示されます：
```
[trust this file] or [deny and ignore this file] or [preview]
```

信頼する場合は`t`を押してください。

## セキュリティ

### 信頼ファイル管理

- 信頼されたファイルは`~/.local/share/nvim/trustedfiles.json`に保存されます
- ファイルが変更されると、再度確認プロンプトが表示されます
- 悪意あるコードからシステムを保護するため、Neovim 0.9+のセキュリティ機構が動作します

### ベストプラクティス

1. **Gitで管理**: `.nvim.lua`をGitリポジトリに含め、チームで共有
2. **レビュー**: プロジェクトに参加する際は、`.nvim.lua`の内容を必ず確認
3. **最小限の権限**: 必要最小限の設定のみを記述
4. **秘密情報の禁止**: パスワードやAPIキーを含めない

## テンプレートの内容

`.nvim.lua.template`には以下の言語/フレームワーク用の設定例が含まれています：

- **Python** (uv + ruff)
- **TypeScript/JavaScript** (prettier + eslint)
- **PHP/Laravel** (pint)
- **Ruby** (rubocop)
- **Go** (gofmt/goimports)

## よくある使用例

### Python プロジェクト (uv + ruff)

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.name == "pyright" then
            vim.keymap.set('n', 'gl', function()
                vim.cmd('!uv run ruff format %')
                vim.cmd('edit!')
            end, { buffer = args.buf })
        end
    end,
})
```

### TypeScript/JavaScript プロジェクト

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.name == "tsserver" then
            vim.keymap.set('n', 'gl', function()
                vim.cmd('!npx prettier --write %')
                vim.cmd('edit!')
            end, { buffer = args.buf })
        end
    end,
})
```

### Laravel プロジェクト

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.name == "intelephense" then
            vim.keymap.set('n', 'gl', function()
                vim.cmd('!./vendor/bin/pint %')
                vim.cmd('edit!')
            end, { buffer = args.buf })
        end
    end,
})
```

## トラブルシューティング

### 設定が読み込まれない

- `exrc`が有効か確認: `:set exrc?` → `exrc`と表示されるべき
- ファイル名が正しいか確認: `.nvim.lua`（`.`で始まる）
- プロジェクトルートに配置されているか確認

### 信頼プロンプトが表示されない

- ファイルが既に信頼されている可能性があります
- `~/.local/share/nvim/trustedfiles.json`を確認

### 変更が反映されない

- Neovimを再起動してください
- `:source .nvim.lua`で手動読み込みも可能（ただし信頼チェックはスキップされます）

## 参考

- [Neovim exrc documentation](https://neovim.io/doc/user/options.html#'exrc')
- [Neovim security](https://neovim.io/doc/user/starting.html#_security)
