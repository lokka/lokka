Lokka Hatena Bookmark Button
============================

これは、[はてなブックマークボタン](http://b.hatena.ne.jp/guide/bbutton)を作成する[Lokka](http://lokka.org)用のプラグインです。

インストール
------------

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-hatena_bookmark_button.git

使い方
------

管理画面の[プラグイン]->[Hatena Bookmark Button]でオプションを設定することができます。

ヘルパーメソッドとして、「hatena_bookmark_button」があります。テーマのテンプレートを変更することをお忘れずにお願いします。このヘルパーメソッドには、引数が二つあります。一番目はタイトルを指定し、二番目はURLです。URLを指定しなかった場合、表示しているページのURLを使います。

    <%= hatena_bookmark_button(@entry.title) %>

URLを指定したい場合は、文字列引数としてメソッドに指定してください。

    <%= hatena_bookmark_button(@entry.title, "http://example.com/foo/bar/") %>

注意点
------

この引数で指定するタイトルは、はてなブックマークボタンをクリックした後に表示される小ウィンドウに用いられ、はてなブックマーク登録ページにおいては、URLのtitle要素が設定されます。したがって、ローカル環境では、当然のことながら外部(はてな側)からtitle要素を取得できません。
