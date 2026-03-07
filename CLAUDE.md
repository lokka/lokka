# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

LokkaはSinatra + ActiveRecordベースの軽量Ruby製CMS。テーマ・プラグインによる拡張、Heroku/Docker対応。

## 開発コマンド

```bash
# セットアップ
bundle install --without=production:test
bundle exec rake db:setup

# 実行
bundle exec rackup
# http://localhost:9292/

# テスト
bundle exec rake spec

# 単一テストファイル実行
bundle exec rspec spec/integration/admin/posts_spec.rb

# Lint
bundle exec rubocop
bundle exec haml-lint

# 管理画面JSビルド
bundle exec rake admin:build_js

# DB操作
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake db:reset  # delete + seed
```

## アーキテクチャ

### エントリーポイント
`config.ru` → `init.rb` → `lib/lokka.rb` → `lib/lokka/app.rb`

### 主要コンポーネント

| パス | 役割 |
|------|------|
| `lib/lokka/app.rb` | メインSinatraアプリケーション |
| `lib/lokka/app/admin.rb` | 管理画面ルート（/admin/*） |
| `lib/lokka/app/entries.rb` | フロントエンドルート |
| `lib/lokka/models/` | ActiveRecordモデル |
| `lib/lokka/helpers/` | ビューヘルパー、レンダリング |
| `lib/lokka/before.rb` | 認証・認可ロジック |

### テーマシステム
`public/theme/テーマ名/` に配置。ERB/Haml/Slim対応（優先順）。

必須テンプレート: `layout`, `entries`, `entry`

### プラグインシステム
`public/plugin/lokka-プラグイン名/` に配置。Sinatra extensionパターンで登録。

```ruby
module Lokka::PluginName
  def self.registered(app)
    app.get '/admin/plugins/xxx' do
      # ...
    end
  end
end
```

### 主要モデル
- `Entry` - 記事・ページ（type: Post/Page, draft flag）
- `User` - ユーザー認証
- `Site` - サイト設定（タイトル、テーマ等）
- `Category`, `Tag`, `Comment`, `Snippet`, `Field`

## テスト

RSpec + FactoryBot + Rack::Test。`spec/factories.rb`でダミーデータ定義。

- `spec/integration/` - 結合テスト
- `spec/unit/` - ユニットテスト

環境変数: `RACK_ENV=test`, `LOKKA_ENV=test`

## 国際化

`i18n/` ディレクトリに `en.yml`, `ja.yml`。
