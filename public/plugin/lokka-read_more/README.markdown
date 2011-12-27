Lokka Read More
===============

This is a [Lokka](http://lokka.org) plugin to add "Read more" link in the article.

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-read_more.git

Usage
-----

The default delimiter is "----" line. You can change from admin plugin menu.

The helper is "body_with_more". Don't forget to modify the theme template for "entries" and "entry". For entries template, change to "body_with_more(post)". For entry template, change to "body_with_more(@entry)".
