# Deploying Lokka with Kamal

This guide explains how to deploy Lokka to a Sakura VPS (or any Linux server) using Kamal.

## Prerequisites

- A server running Ubuntu 22.04+ or Debian 12+ with SSH access
- Docker installed on the server
- A domain name pointing to your server
- GitHub account (for container registry)

## Server Setup

1. Install Docker on your server:

```bash
ssh root@your-server-ip
curl -fsSL https://get.docker.com | sh
```

2. Add your SSH public key to the server for passwordless login.

## Local Setup

1. Install Kamal:

```bash
gem install kamal
```

2. Copy the secrets example file and fill in your values:

```bash
cp .kamal/secrets.example .kamal/secrets
```

3. Edit `.kamal/secrets` with your actual values:

```bash
# GitHub Container Registry credentials
KAMAL_REGISTRY_USERNAME=your-github-username
KAMAL_REGISTRY_PASSWORD=ghp_your-personal-access-token

# Server configuration
DEPLOY_HOST=your-sakura-vps-ip
DEPLOY_DOMAIN=your-domain.com
LETSENCRYPT_EMAIL=your-email@example.com

# Database credentials
POSTGRES_USER=lokka
POSTGRES_PASSWORD=$(openssl rand -hex 32)
DATABASE_URL=postgres://lokka:your-password@lokka-db:5432/lokka_production

# Application secret
SECRET_KEY_BASE=$(openssl rand -hex 64)
```

## GitHub Personal Access Token

Create a GitHub Personal Access Token with `write:packages` permission:

1. Go to https://github.com/settings/tokens/new
2. Select "write:packages" scope
3. Generate and copy the token

## Deploy

First time setup (creates containers and database):

```bash
kamal setup
```

Run database migrations:

```bash
kamal app exec 'bundle exec rake db:migrate'
```

Seed the database (first time only):

```bash
kamal app exec 'bundle exec rake db:seed'
```

## Subsequent Deploys

```bash
kamal deploy
```

## Useful Commands

```bash
# View logs
kamal app logs

# Access Rails console
kamal app exec -i 'bundle exec irb -r ./init'

# Restart the app
kamal app restart

# View running containers
kamal details

# Rollback to previous version
kamal rollback
```

## Troubleshooting

### Check container status

```bash
kamal app details
```

### View Traefik logs

```bash
kamal traefik logs
```

### SSH into the server

```bash
kamal app exec -i bash
```
