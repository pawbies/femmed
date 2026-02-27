<div align="center">

<img src="public/icon.png" alt="femmed logo" width="120" />

# femmed

**medication tracking, made by femboys for femboys**

*Track your HRT and medications with something built by people who actually get it.*

</div>

---

femmed is a **self-hosted** medication tracker. Your data stays on your own server — no cloud, no third parties, no accounts with strangers. Just spin it up, and it's yours.

It's built with Rails 8 and SQLite, which means there's no database server to manage. Everything runs in a single process and stores data in a file on disk. It's designed to be easy to host on a cheap VPS or even a Raspberry Pi at home.

---

## Quickstart (Docker — recommended)

The easiest way to run femmed is with Docker. You'll need Docker installed, then:

```bash
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<your_master_key> \
  -v femmed_storage:/rails/storage \
  --name femmed \
  pawbies67/femmed:latest
```

That's it. femmed will be running at `http://your-server-ip`.

> **Don't lose your data:** The `-v femmed_storage:/rails/storage` volume mount is what keeps your database and uploads alive across updates. Don't skip it.

---

## Environment variables

These can be passed to Docker with `-e KEY=value` or via a `.env` file with `--env-file .env`.

| Variable | Required | Description |
|---|---|---|
| `RAILS_MASTER_KEY` | ✅ Yes | Decrypts credentials. Found in `config/master.key` if running locally — never commit this file. |
| `RAILS_ENV` | No | Defaults to `production` in Docker. Set to `development` locally. |
| `SOLID_QUEUE_IN_PUMA` | No | Set to `true` (default) to run background jobs inside the web process. Set to `false` if running a dedicated worker. |
| `PORT` | No | Port the app listens on inside the container. Defaults to `80`. |

---

## Updating

With Docker, pull the latest image and restart:

```bash
docker pull ghcr.io/pawbies67/femmed:latest
docker stop femmed && docker rm femmed
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<your_master_key> \
  -v femmed_storage:/rails/storage \
  --name femmed \
  pawbies67/femmed:latest
```

Your data is safe as long as the `femmed_storage` volume is intact.

---

## Deploying with Kamal (zero-downtime)

If you want proper zero-downtime deploys to your own VPS, femmed supports [Kamal 2](https://kamal-deploy.org/):

```bash
# First-time setup — installs Docker on the server and deploys
bin/kamal setup

# Subsequent deploys
bin/kamal deploy
```

Populate `.kamal/secrets` with your environment variables before running either command.

> **Tip:** If you see a DNS resolution error in the kamal-proxy logs after a server restart, run `kamal proxy reboot` to fix it.

---

## Running locally for development

### Requirements

- **Ruby 3.4.1** — use [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/) to install it (they'll pick up the version from `.ruby-version` automatically)
- **Bundler** — `gem install bundler`
- **SQLite3** — usually pre-installed on macOS; on Ubuntu: `apt-get install sqlite3 libsqlite3-dev`
- **libvips** — for image processing. macOS: `brew install libvips`. Ubuntu: `apt-get install libvips`

### Setup

```bash
bundle install
bin/rails db:setup
bin/dev
```

femmed will be available at `http://localhost:3000`.

---

<div align="center">

made with 💗 by femboys, for femboys

</div>
