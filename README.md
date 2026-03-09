# Lokka

> **Note**
> Lokka 1.0.0 has migrated from DataMapper to **ActiveRecord**.
> If you are upgrading from v0.6.0 or earlier, please see the [Migration Guide](https://github.com/lokka/lokka/wiki/Migration-Guide-DataMapper-to-ActiveRecord).

CMS written in Ruby for cloud computing.

## Requirements

- Ruby 3.2 or later
- SQLite

## Features

* Performs in the cloud environment such as Google App Engine and Heroku as well as Windows, Mac, and Linux.
* Designed with reference to WordPress for WordPress users to easily understand.
* Easy installation
* Easy to create a theme for designers.
* A clear plug-in API for Rubyists

## Installation

```sh
$ git clone git://github.com/lokka/lokka.git
$ cd lokka
$ bundle install --without=production:test
$ bundle exec rake db:setup
$ bundle exec rackup
```

View at: http://localhost:9292/

## Deployment

See the [Deployment Guide](https://github.com/lokka/lokka/wiki/Deployment) for production deployment instructions using Kamal.

## Docker (Development)

```sh
$ docker-compose build
$ docker-compose run --rm app bundle exec rake db:setup
$ docker-compose up
```

open http://localhost:9292 on your browser.

## Test

```sh
rake test
```

## How to make a theme

Make a directory for theme in public/theme and you need to create entries.erb and entry.erb at least. (erb and haml are available.)

### Index page

public/theme/example/entries.erb:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>Example</title>
  </head>
  <body>
    <h1><%= @site.title %></h1>
    <% @entries.each do |entry| %>
      <h2><%= entry.title %></h2>
      <div class="body"><%= entry.body %></div>
    <% end %>
  </body>
</html>
```

### Individual page

public/theme/example/entry.erb:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>Example</title>
  </head>
  <body>
    <h1><%= @site.title %></h1>
    <h2><%= @entry.title %></h2>
    <div class="body"><%= @entry.body %></div>
  </body>
</html>
```

## How to make a plugin

Lokka Plugin is subset of [Sinatra Extension](http://www.sinatrarb.com/extensions.html). but Lokka had a specific rules of nomenclature.
If you need display "Hello, World" when access to "/hello", Write a following.

public/plugin/lokka-hello/lib/lokka/hello.rb:

```ruby
module Lokka::Hello
  def self.registerd(app)
    app.get '/hello' do
      'hello'
    end
  end
end
```

## Copyright

Copyright (c) 2010 Masaki Komagata. See LICENSE for details.
