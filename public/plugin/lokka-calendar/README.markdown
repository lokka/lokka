Lokka Calendar
==============

This is a [Lokka](http://lokka.org) plugin to add a calendar.

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-calendar.git

Usage
-----

There is one helper method called "calendar". Please insert to your theme like:

    <dt><%= t.calendar %></dt>
    <dd>
      <ul>
        <%= calendar %>
      </ul>
    </dd>

Notice
------

The CSS, public/plugin/lokka-calendar/views/calendar.css, is designed for "jarvi" theme. Maybe you will be needed to modifiy this CSS file for your theme.
