Lokka Read More
===============

これは、『続きを読む』リンクを作成する[Lokka](http://lokka.org)用のプラグインです。

インストール
------------

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-read_more.git


使い方
------

既定の区切り（続きを読むリンクを作成する箇所）は、「----」です。これは、プラグインの管理画面で変更が可能です。

ヘルパーメソッドとして、「body_with_more」があります。テーマのテンプレート、「entries」と「entry」を変更することをお忘れずにお願いします。entriesテンプレートは、「body_with_more(post)」に。entryテンプレートは、「body_with_more(@entry)」です。
