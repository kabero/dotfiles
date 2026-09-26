#!/bin/sh
# gitleaks でステージされた変更に秘密情報が混入していないか検査する
if ! command -v gitleaks >/dev/null 2>&1; then
	echo "pre-commit: gitleaks が見つからないため秘密情報スキャンをスキップしました" >&2
	exit 0
fi

if ! gitleaks git --pre-commit --staged --redact --no-banner; then
	echo "" >&2
	echo "pre-commit: 秘密情報の混入を検知したためコミットを中止しました" >&2
	exit 1
fi
