# Qovery Documentation Cloudflare Worker

This Cloudflare Worker proxies requests from `www.qovery.com/docs/*` to the Mintlify-hosted documentation at `qovery.mintlify.dev`.

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure Wrangler with your Cloudflare credentials:
   ```bash
   npx wrangler login
   ```

3. Deploy the worker:
   ```bash
   npm run deploy
   ```

## Development

To test the worker locally:
```bash
npm run dev
```

## Configuration

- `worker.js` - Main worker code that handles the proxying logic
- `wrangler.toml` - Cloudflare Worker configuration
- The worker is configured to route `www.qovery.com/docs/*` to `qovery.mintlify.dev`
