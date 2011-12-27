Lokka Hatena Bookmark Button
============================

This is a [Lokka](http://lokka.org) plugin to add ["Hatena Bookmark Button"](http://b.hatena.ne.jp/guide/bbutton) link.

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-hatena_bookmark_button.git

Usage
-----

You can set options in the admin page [Plugins]->[Hatena Bookmark Button].

The helper method is "hatena_bookmark_button".  Don't forget to modify the theme template. This helper method has two parameters. First is for title and second is URL. If the hatena_bookmark_button method called without URL, current page URL will be used. If you want to specify the URL, call the method with String parameter like:

    <%= hatena_bookmark_button(@entry.title, "http://example.com/foo/bar/") %>
