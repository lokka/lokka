# Lokka Turnstile

Protects public comment submissions with [Cloudflare Turnstile](https://www.cloudflare.com/application-services/products/turnstile/).

Create a Turnstile widget in the Cloudflare dashboard, then configure its site key and secret key from **Admin > Plugins > Turnstile**.

Alternatively, set both environment variables:

```text
TURNSTILE_SITE_KEY=...
TURNSTILE_SECRET_KEY=...
```

Turnstile is enabled only when both keys are configured. Logged-in Lokka users are not challenged.
