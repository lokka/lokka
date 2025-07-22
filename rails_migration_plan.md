# Lokka to Rails 7.2 Migration Plan

## Overview
Migrating Lokka CMS from Sinatra + DataMapper to Rails 7.2 + ActiveRecord for Ruby 3.4.3 compatibility.

## Current Architecture Analysis

### Models (DataMapper)
- Entry (base class for Post/Page)
- Post (blog posts)
- Page (static pages)
- User
- Category
- Comment
- Tag
- Site (site configuration)
- Option (key-value settings)
- Field/FieldName (custom fields)
- Snippet
- Theme
- Markup (markup engines)

### Features
1. **Content Management**
   - Posts and Pages (STI pattern)
   - Categories and Tags
   - Comments with moderation
   - Custom fields
   - Drafts

2. **User System**
   - Authentication
   - Permission levels (admin/editor)
   - Password encryption

3. **Theme System**
   - File-based themes
   - Support for ERB, Haml, Slim
   - Theme switching

4. **Plugin Architecture**
   - Sinatra extension based
   - Auto-loading from public/plugin/

5. **Markup Support**
   - Markdown
   - Textile
   - Plain HTML

## Migration Steps

### Phase 1: Rails Setup
1. Create new Rails 7.2 app with Ruby 3.4.3
2. Configure SQLite database
3. Setup basic gems (haml, slim, bcrypt, etc.)

### Phase 2: Model Migration
1. Create ActiveRecord migrations
2. Port model validations and associations
3. Implement STI for Entry/Post/Page
4. Add custom field support

### Phase 3: Authentication
1. Implement session-based auth (no Devise initially)
2. Port User model with bcrypt
3. Add permission system

### Phase 4: Admin Interface
1. Create admin namespace
2. Port CRUD operations
3. Implement file upload

### Phase 5: Public Interface
1. Port theme rendering system
2. Implement theme switching
3. Add RSS/Atom feeds

### Phase 6: Plugin System
1. Design Rails-compatible plugin architecture
2. Port existing plugins

## Directory Structure Mapping

```
Lokka                          → Rails
├── lib/lokka/models/         → app/models/
├── lib/lokka/app/           → app/controllers/
├── public/admin/            → app/views/admin/
├── public/theme/            → app/views/themes/
├── public/plugin/           → lib/plugins/
├── i18n/                    → config/locales/
└── db/seeds.rb              → db/seeds.rb
```

## Key Challenges
1. DataMapper → ActiveRecord query syntax
2. Sinatra helpers → Rails helpers
3. Theme system architecture
4. Plugin loading mechanism
5. Route structure differences