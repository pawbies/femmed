<div align="center">

<img src="public/icon.png" alt="femmed logo" width="120" />

# femmed

**medication tracking, made by femboys for femboys**

*Track your HRT and medications with something built by people who actually get it.*

</div>

---

## Ruby version

femmed runs on **Ruby 3.4.1**. You can check your current version with `ruby -v`. (Local Ruby installation is not required if you use docker.)

We recommend using a Ruby version manager to install and switch between versions. The two most popular options are [rbenv](https://github.com/rbenv/rbenv) and [mise](https://mise.jdx.dev/). Once installed, they will automatically pick up the correct version from the `.ruby-version` file in the project root.

```bash
# with rbenv
rbenv install 3.4.1

# with mise
mise install ruby@3.4.1
```

---

## System dependencies

femmed is a standard Rails 8 application using SQLite3 as its database, which means there's no need to install or run a separate database server.

You will need the following installed on your system (unless you use docker):

- **Ruby 3.4.1**
- **Bundler** — Ruby's dependency manager, used to install gems (`gem install bundler`)
- **SQLite3** — usually pre-installed on macOS and most Linux distros; on Ubuntu run `apt-get install sqlite3 libsqlite3-dev`
- **libvips** — used for image processing by Active Storage. On macOS: `brew install libvips`. On Ubuntu: `apt-get install libvips`

Once you have those, install the Ruby gem dependencies:

```bash
bundle install
```

---

## Database creation

The database is a SQLite3 file stored locally on disk. To create it along with all the required tables, run:

```bash
bin/rails db:setup
```

This is a combined command that creates the database, loads the schema, and runs any seed data all in one step. If you just want to create the database without seeding it, you can run `bin/rails db:create` followed by `bin/rails db:migrate` separately.

If you're running femmed via Docker, database creation happens automatically on startup — the entrypoint script runs `db:prepare` which creates and migrates the database if it doesn't already exist, so you don't need to do anything manually.

---

## How to run the test suite

femmed uses Rails' built-in testing framework (Minitest). To run the full test suite:

```bash
bin/rails test
```

To run a specific test file:

```bash
bin/rails test test/models/medication_test.rb
```

To run a specific test by line number:

```bash
bin/rails test test/models/medication_test.rb:42
```

Make sure you have a clean test database before running tests. Rails handles this automatically using a separate `test` environment database, but if something seems off you can reset it with `bin/rails db:test:prepare`.

---

## Services (job queues, cache servers, search engines, etc.)

femmed uses Rails' **Solid** suite, which means background jobs, caching, and the Action Cable backend all run on top of SQLite — no Redis, no Memcached, no external services required.

- **Solid Queue** handles background job processing. In single-server deployments it runs inside the Puma web process (controlled by the `SOLID_QUEUE_IN_PUMA` environment variable). If you scale to multiple servers, you'd move job processing to a dedicated worker by running `bin/jobs` on a separate host.
- **Solid Cache** handles Rails caching, again backed by SQLite, so cache data persists across restarts.
- **Solid Cable** handles Action Cable (WebSocket) connections if used.

None of these require any setup — they work out of the box as part of the normal server startup.

---

## Deployment instructions

### Manually

For a basic manual deployment on a Linux server:

1. Install Ruby, Bundler, and system dependencies on the server (see above)
2. Clone the repo and `bundle install`
3. Set the `RAILS_MASTER_KEY` environment variable (found in `config/master.key` locally — never commit this file)
4. Run `RAILS_ENV=production bin/rails db:prepare` to set up the database
5. Precompile assets: `RAILS_ENV=production bin/rails assets:precompile`
6. Start the server: `RAILS_ENV=production bin/rails server`

You'll likely want to put Nginx or Caddy in front of Rails in a manual setup to handle SSL and static asset serving.

### Via Docker

The included `Dockerfile` builds a production-ready image using Thruster as an internal HTTP proxy in front of Puma, listening on port 80. The entrypoint automatically runs `db:prepare` on startup so the database is always up to date.

```bash
# Build the image
docker build -t femmed .

# Run it
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<your_master_key> \
  -v femmed_storage:/rails/storage \
  --name femmed femmed
```

The `-v femmed_storage:/rails/storage` volume mount is important — it persists your SQLite database and any uploaded files across container restarts and redeployments. Without it, all data is lost every time the container is replaced.

### Via Kamal (recommended)

femmed is configured for deployment with [Kamal 2](https://kamal-deploy.org/), which automates zero-downtime Docker deployments to your own server.

```bash
# First time setup — installs Docker on the server and deploys
bin/kamal setup

# Subsequent deploys
bin/kamal deploy
```

Make sure your `.kamal/secrets` file is populated with the required environment variables before running either command. Kamal handles building the image, pushing it to the registry, and orchestrating the rollover on the server.

> **Tip:** If you ever see a DNS resolution error in the kamal-proxy logs after a server restart, run `kamal proxy reboot` to fix the Docker network connection between the proxy and your app container.

---

<div align="center">

made with 💗 by femboys, for femboys

</div>