Lokka Tweet Button
==================

This is a [Lokka](http://lokka.org) plugin to add ["Tweet Button"](http://twitter.com/goodies/tweetbutton) link.

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-tweet_button.git

Usage
-----

You can set options in the admin page [Plugins]->[Tweet Button].

The helper method is "tweet_button".  Don't forget to modify the theme template. If the tweet_button method called without any parameter, current page URL will be tweeted. If you want to specify the URL, call the method with String parameter like:

    <%= tweet_button("http://example.com/foo/bar/") %>

Notice
------

When the URL starts with "http://localhost" and clicked the Tweet button, you will get "URL required - 'url' parameter does not contain a valid URL." message from Twitter.
