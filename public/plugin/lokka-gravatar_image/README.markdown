Lokka Gravatar Image
====================

This is a [Lokka](http://lokka.org) plugin for [Gravatar Image requests](http://www.gravatar.com/site/implement/images/).

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-gravatar_image.git

Usage
-----

The helper is "gravatar_image_url". The first parameter is email and second is image size which is optional. If you didn't specify the image size, it will be 80px as the Gravatar Image request default.

    <img src="<%= gravatar_image_url(post.user.email) %>"/>
    <img src="<%= gravatar_image_url(@entry.user.email, 16) %>"/>

You can specify other options, like rating, in the Admin->[Plugins]->[Gravatar Image].
