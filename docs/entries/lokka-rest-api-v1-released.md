---
layout: default
title: "Lokka REST API v1 Released - Lokka"
breadcrumb: "Lokka REST API v1 Released"
date: 2026-03-27
---

## Lokka REST API v1 Released

We are excited to announce that Lokka now includes a built-in REST API (v1). This enables programmatic access to your Lokka site — perfect for automation, external integrations, and headless CMS workflows.

### Authentication

The API uses Bearer token authentication. First, obtain a token by posting your credentials:

```bash
curl -X POST https://your-site.example.com/api/v1/token \
  -H "Content-Type: application/json" \
  -d '{"name": "your_username", "password": "your_password"}'
```

Then include the token in subsequent requests:

```
Authorization: Bearer YOUR_TOKEN
```

### Available Endpoints

| Resource    | GET (list) | GET (show) | POST (create) | PUT (update) | DELETE |
|-------------|:---:|:---:|:---:|:---:|:---:|
| Posts       | ✓ | ✓ | ✓ | ✓ | ✓ |
| Pages       | ✓ | ✓ | ✓ | ✓ | ✓ |
| Categories  | ✓ | ✓ | ✓ | ✓ | ✓ |
| Tags        | ✓ | ✓ | — | ✓ | ✓ |
| Comments    | ✓ | ✓ | ✓ | ✓ | ✓ |
| Snippets    | ✓ | ✓ | ✓ | ✓ | ✓ |
| Users       | ✓ | ✓ | — | — | — |
| Site        | ✓ | — | — | ✓ | — |
| Me          | ✓ | — | — | — | — |

All endpoints are under `/api/v1/` and return JSON responses with pagination support.

### Example: Creating a Post

```bash
curl -X POST https://your-site.example.com/api/v1/posts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "post": {
      "title": "Hello from the API",
      "body": "This post was created via the Lokka REST API.",
      "markup": "redcarpet",
      "tags": ["api", "automation"]
    }
  }'
```

### Implementation Details

The API is implemented as a Sinatra extension module (`Lokka::Api`), following the same pattern as other Lokka modules like `Lokka::Before`. The full source is in `lib/lokka/app/api.rb`.

For more details, see [Pull Request #331](https://github.com/lokka/lokka/pull/331).
