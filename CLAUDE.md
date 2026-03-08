# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Lokka is a CMS written in Ruby, designed for cloud environments (Heroku, Google App Engine) and local deployment. Built with Sinatra 4.0 and ActiveRecord 8.1, it follows WordPress-like concepts with theme and plugin extensibility.

## Common Commands

```bash
# Development server
bundle exec rackup

# Run all tests
bundle exec rake spec

# Run a single test file
bundle exec rspec spec/unit/post_spec.rb

# Run tests matching a pattern
bundle exec rspec spec/integration/admin/

# Database operations
bundle exec rake db:setup      # migrate + seed
bundle exec rake db:migrate    # run migrations
bundle exec rake db:seed       # seed initial data
bundle exec rake db:reset      # delete + seed

# Code style
rubocop lib/
haml-lint public/

# Admin JS build
bundle exec rake admin:build_js
```

## Architecture

### Application Structure

- `lib/lokka.rb` - Top-level module with environment helpers (`Lokka.root`, `Lokka.env`)
- `lib/lokka/app.rb` - Sinatra application base class (`Lokka::App`)
- `lib/lokka/app/admin.rb` - Admin panel routes (`/admin/*`)
- `lib/lokka/app/entries.rb` - Public entry display routes
- `lib/lokka/database.rb` - ActiveRecord connection and migration management
- `lib/lokka/helpers/` - View helpers and rendering logic

### Models (`lib/lokka/models/`)

Core models using ActiveRecord:
- `Entry` - Base class for posts/pages (STI: `Post`, `Page`)
- `User` - Authentication and authorship
- `Category` - Entry categorization
- `Tag`, `Tagging` - Polymorphic tagging system
- `Field`, `FieldName` - Custom fields for entries
- `Site` - Site-wide settings (singleton)
- `Option` - Key-value configuration store
- `Comment`, `Snippet`, `Markup`, `Theme`

### Theme System (`public/theme/`)

Themes require at minimum `entries.erb` and `entry.erb`. Supports ERB, HAML, and Slim templates. Template variables: `@site`, `@entries`, `@entry`.

### Plugin System (`public/plugin/`)

Plugins follow naming convention `lokka-<name>` and are Sinatra extensions:

```ruby
module Lokka::PluginName
  def self.registered(app)
    # Add routes, helpers, etc.
  end
end
```

Plugins can include their own `Gemfile` (auto-loaded) and `i18n/` directory.

## Testing

- Framework: RSpec with FactoryBot
- Test database: SQLite3 (in-memory or `db/test.sqlite3`)
- Factories: `spec/factories.rb`
- Integration tests: `spec/integration/` (Rack::Test for HTTP testing)
- Unit tests: `spec/unit/`

## Key Configuration

- Ruby >= 3.3 required
- Database config: `database.yml` (copy from `database.default.yml`)
- Default locale: `en` (i18n files in `i18n/`)
- Session expires: 24 days
- Pagination: 10 entries (public), 200 entries (admin)
