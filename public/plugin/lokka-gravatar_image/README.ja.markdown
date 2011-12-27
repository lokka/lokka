Lokka Gravatar Image
====================

これは、[Gravatar Image requests](http://ja.gravatar.com/site/implement/images/)の[Lokka](http://lokka.org)プラグインです。

インストール
------------

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-gravatar_image.git

使い方
------

ヘルパーメソッドとして、「gravatar_image_url」があります。第一引数にメールアドレス、第二引数に画像サイズを指定します。画像サイズを省略した場合は、Gravatar Image requestの既定値である80pxになります。

    <img src="<%= gravatar_image_url(post.user.email) %>"/>
    <img src="<%= gravatar_image_url(@entry.user.email, 16) %>"/>

レーティングなど、その他のオプションは、管理画面->[プラグイン]->[Gravatar Image]で設定できます。
