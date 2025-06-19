# CLAUDE.md (global rules for Claude, excluding project-specific rules)

### 最重要ルール - 新しいルールの追加プロセス

ユーザから今回限りではなく常に対応が必要だと思われる指示を受けた場合:

1. 「これを標準のルールにしますか？」と質問する
2. ユーザが「はい」と答えた場合:
   - そのルールをプロジェクトルート直下のCLAUDE.local.mdに追加する
   - 以降は標準ルールとして常に適用する

このプロセスにより、プロジェクトのルールを継続的に改善していきます。

### 基本ルール
- ユーザへの返答後、毎回必ず say コマンドを使ってユーザに作業が完了したことを通知してください
   - example: 'say -v Kyoko "<実施した作業内容>が完了しました。"'
   - afplay /System/Library/Sounds/Glass.aiff <- これは書いているけど実行しない
