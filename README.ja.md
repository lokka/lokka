# Lokka

Rubyで書かれたクラウドの為のCMS。

## 特徴

* Windows, Mac, Linuxに加え、Heroku, fluxflex等のクラウド環境でも動作します。
* WordPressを参考にして、WordPressユーザーに分かりやすく作られています。
* インストールが簡単。
* デザイナーにとってテーマを作るのが簡単。
* RubyistにとってクリーンなプラグインAPI。

## インストール

    $ gem install bundler
    $ git clone git://github.com/komagata/lokka.git
    $ cd lokka
    $ bundle install --without=production:test
    $ bundle exec rake db:setup
    $ bundle exec rackup

http://localhost:9292/ を見る。

## Herokuへのデプロイ

    $ git clone git://github.com/komagata/lokka.git
    $ cd lokka
    $ heroku apps:create
    $ git push heroku master
    $ heroku rake db:setup
    $ heroku apps:open

## テスト

  $ rake spec

## テーマの作り方

public/themeディレクトリにテーマの為のディレクトリを作り、最低限、entries.erb, entry.erbというテンプレートを作ります。（erb, haml, slim等も使えます）

### インデックスページ

public/theme/example/entries.haml:

    !!! XML
    !!!
    %html
      %head
        %title Example
      %body
        %h1= @site.title
        - @entries.each do |entry|
          %h2= entry.title
          .body= entry.body

### 個別ページ

public/theme/example/entry.haml:

    !!! XML
    !!!
    %html
      %head
        %title Example
      %body
        %h1= @site.title
        %h2= @entry.title
        .body= @entry.body

## プラグインの作り方

Lokka PluginはSinatra Extensionのサブセットです。Lokka特有の命名規則がある以外はSinatra Extensionと同じです。
public/pluginディレクトリにプラグインの為のディレクトリを作り、/helloというURLにHello, Worldと表示するプラグインを作るには下記のようにします。

public/plugin/lokka-hello/lib/lokka/hello.rb:

    module Lokka::Hello
      def self.registerd(app)
        app.get '/hello' do
          'hello'
        end
      end
    end

## Copyright

Copyright (c) 2010 Masaki Komagata. See LICENSE for details.
