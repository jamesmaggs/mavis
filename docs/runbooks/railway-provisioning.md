# Railway provisioning runbook

Mavis deploys to [Railway](https://railway.com). Build/deploy *settings* live
in code (`railway.toml` → builds the committed `Dockerfile`), but Railway does
**not** yet let service creation, environment variables, or tokens live in
`railway.toml` (config-as-code is build/deploy only). Those steps are manual
and recorded here. Migrating to full infrastructure-as-code (`railway.ts`) is
deferred — see [ADR 0001](../adrs/0001-railway-config-as-code-over-full-iac.md).

The deploy pipeline is owned by GitHub Actions (`.github/workflows/ci.yml`),
not Railway auto-deploy. On push to `main`: `verify` (build + test) gates a
`deploy` job that runs `railway up --ci --service mavis`.

## Current provisioned resources

| Resource | Value |
|---|---|
| Workspace | `My Projects` (`bdcdf93b-895c-4ef0-a505-f7ace062bd8c`) |
| Project | `mavis` (`412d9b33-79f5-4d5b-a978-cda681651b94`) |
| Environment | `production` (`215ab863-f6c1-468a-84af-c29ba6a49197`) |
| Service | `mavis` (`7bd2f805-b6e6-41d5-8367-de21d56cdb5d`) |
| Public domain | https://mavis-production-c8c2.up.railway.app |
| Service var | `PORT=8080` (app binds it; domain routes to it) |

## Prerequisites

- `mise` (toolchain), `gh` (GitHub CLI, authenticated), and the Railway CLI.
  Install the Railway CLI with `mise`/`brew`/`npm` as preferred.

## One-time provisioning (what was run)

1. **Authenticate** — interactive, requires a browser, so run it in a real
   terminal (the non-interactive agent shell cannot complete the OAuth flow):

   ```sh
   railway login
   ```

2. **Create project + link this directory** (workspace must be named/ID'd when
   run non-interactively):

   ```sh
   railway init --name mavis --workspace bdcdf93b-895c-4ef0-a505-f7ace062bd8c
   ```

3. **Add the service**:

   ```sh
   railway add --service mavis
   ```

4. **Set the listen port** (Railway does not inject `PORT` by default; the app
   reads it, else defaults to 7070). Setting it triggers a redeploy:

   ```sh
   railway variable set PORT=8080 --service mavis
   ```

5. **Generate the public domain**, routed to the same port:

   ```sh
   railway domain --service mavis --port 8080
   ```

6. **First deploy** (subsequent deploys are automated by CI):

   ```sh
   railway up --service mavis --ci
   ```

## Enabling automated CI deploys

1. In the Railway dashboard: **mavis → Settings → Tokens** → create a
   **Project Token** scoped to the `production` environment.
2. Store it as a GitHub Actions secret (never commit it, never paste it into
   an agent chat). From a real terminal or the GitHub UI:

   ```sh
   gh secret set RAILWAY_TOKEN   # paste the token at the prompt
   ```

The `deploy` job reads `RAILWAY_TOKEN` and runs `railway up --ci --service
mavis` inside the `ghcr.io/railwayapp/cli` container.

## Verifying a deploy

```sh
curl -s -w '\n[http %{http_code}]\n' https://mavis-production-c8c2.up.railway.app/
# expect: hello world  /  http 200
```
