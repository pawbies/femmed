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
git clone https://github.com/pawbies/femmed
cd femmed
cp .env.example .env
```

Open `.env` and fill in the required values. To generate the secret keys, run these commands inside the repo:

```bash
# Generate SECRET_KEY_BASE
docker run --rm -it ruby:4.0.1-slim bin/rails secret

# Generate the Active Record encryption keys
docker run --rm -v "$PWD":/rails -w /rails ruby:3.4.1-slim bundle exec rails db:encryption:init
```

Or if you have Ruby installed locally:

```bash
bundle install
bin/rails secret                  # → SECRET_KEY_BASE
bin/rails db:encryption:init      # → the three ACTIVE_RECORD_ENCRYPTION_* keys
```

Once your `.env` is filled in, build and run:

```bash
docker build . -t femmed
docker run --env-file .env -p 80:80 -v femmed_storage:/rails/storage femmed
```

femmed will be running at `http://your-server-ip`.

> **Don't lose your data:** The `-v femmed_storage:/rails/storage` volume mount is what keeps your database and uploads alive across updates. Don't skip it.

---

## Updating

Pull the latest code and rebuild:

```bash
git pull
docker stop femmed && docker rm femmed
docker build . -t femmed
docker run --env-file .env -p 80:80 -v femmed_storage:/rails/storage femmed
```

Your data is safe as long as the `femmed_storage` volume is intact.

---

## Running locally for development

### Requirements

- **Ruby 4.0.1** — use [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/) to install it (they'll pick up the version from `.ruby-version` automatically)
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
