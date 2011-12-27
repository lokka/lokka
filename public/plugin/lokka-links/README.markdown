Lokka Links
===========

This is a [Lokka](http://lokka.org) plugin to make a link list.

Installation
------------

Run these commands:

    $ cd public/plugin
    $ git clone git://github.com/nkmrshn/lokka-links.git
    $ bundle exec rake -f public/plugin/lokka-links/Rakefile db:migrate

Usage
-----

In the admin page, there is a menu item called "Links" in the side menu. You can add and modify your link list.

To show the link list, please modify your theme. There is a method called "sorted" in the Link class. This method will return the link list ordered by sort number. For example in Jarvi theme:

    <dt><%= t.links %></dt>
    <dd>
      <ul>
      <% Link.sorted.each do |link| %>
        <li><a href="<%= link.url %>" target="<%= link.target %>"><%= link.title %></a></li>
      <% end %>
      </ul>
    </dd>
