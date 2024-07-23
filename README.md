# Coingecko Assessment

Use this example app (<https://github.com/nickjj/docker-rails-example> reference: <https://nickjanetakis.com>.) as a base for new project to Dockerize Rails app due to hard time setting up on Mac environment, there was alot of ruby, gem install permission erros that are a common issue found online. The project is hosted on AWS free tier EC2, with Let's Encrypt free SSL, Apache2 hosting on proxy pass reverse. It includes the URL shortener application in root/urls path, the answers to extensions #2 question Contract Calls Knowledge on /mana path, DEX event logs question number 3 on /swap path.

## Table of contents

- [Coingecko Assessment](#coingecko-assessment)
  - [Table of contents](#table-of-contents)
  - [Tech stack](#tech-stack)
    - [Back-end](#back-end)
    - [Front-end](#front-end)
    - [Running this app](#running-this-app)
      - [Clone this repo anywhere you want and move into the directory](#clone-this-repo-anywhere-you-want-and-move-into-the-directory)
      - [Copy an example .env file because the real one is git ignored](#copy-an-example-env-file-because-the-real-one-is-git-ignored)
      - [Build everything](#build-everything)
      - [Setup the initial database](#setup-the-initial-database)
      - [Check it out in a browser](#check-it-out-in-a-browser)
      - [Running the test suite](#running-the-test-suite)
      - [Stopping everything](#stopping-everything)
      - [`run`](#run)
      - [Writing unit and integration tests](#writing-unit-and-integration-tests)
      - [Side Notes](#side-notes)

## Tech stack

### Back-end

- [PostgreSQL](https://www.postgresql.org/)
- [Redis](https://redis.io/)
- [Sidekiq](https://github.com/mperham/sidekiq)
- [Action Cable](https://guides.rubyonrails.org/action_cable_overview.html)
- [ERB](https://guides.rubyonrails.org/layouts_and_rendering.html)

### Front-end

- [esbuild](https://esbuild.github.io/)
- [Hotwire Turbo](https://hotwired.dev/)
- [StimulusJS](https://stimulus.hotwired.dev/)
- [TailwindCSS](https://tailwindcss.com/)
- [Heroicons](https://heroicons.com/)

- **Core**:
  - Use PostgreSQL (`-d postgresql)` as the primary SQL database
  - Use Redis as the cache back-end
  - Use Sidekiq as a background worker through Active Job
  - Use a standalone Action Cable process
- **App Features**:
  - Add `pages` controller with a home page, mana page, swap page
  - Add `up` controller with 2 health check related actions
  - Add `urls` controller to handle URL shortener application and usage report viewing
- **Config**:
  - Log to STDOUT so that Docker can consume and deal with log output
  - Credentials are removed (secrets are loaded in with an `.env` file)
  - Extract a bunch of configuration settings into environment variables
  - Rewrite `config/database.yml` to use environment variables
  - `.yarnc` sets a custom `node_modules/` directory
  - `config/initializers/enable_yjit.rb` to enable YJIT
  - `config/initializers/rack_mini_profiler.rb` to enable profiling Hotwire Turbo Drive
  - `config/initializers/assets.rb` references a custom `node_modules/` directory
  - `config/routes.rb` has Sidekiq's dashboard ready to be used but commented out for safety
  - `Procfile.dev` has been removed since Docker Compose handles this for us
- **Assets**:
  - Use esbuild (`-j esbuild`) and TailwindCSS (`-c tailwind`)
  - Add `postcss-import` support for `tailwindcss` by using the `--postcss` flag
  - Add ActiveStorage JavaScript package
- **Public:**
  - Custom `502.html` and `maintenance.html` pages
  - Generate favicons using modern best practices

Besides the Rails app itself, a number of new Docker related files were added
to the project which would be any file having `*docker*` in its name. Also
GitHub Actions have been set up.

### Running this app

You'll need to have [Docker installed](https://docs.docker.com/get-docker/).
It's available on Windows, macOS and most distros of Linux.

You'll also need to enable Docker Compose v2 support if you're using Docker
Desktop. On native Linux without Docker Desktop you can [install it as a plugin
to Docker](https://docs.docker.com/compose/install/linux/). It's been generally
available for a while now and is stable. This project uses specific [Docker
Compose v2
features](https://nickjanetakis.com/blog/optional-depends-on-with-docker-compose-v2-20-2)
that only work with Docker Compose v2 2.20.2+.

If you're using Windows, it will be expected that you're following along inside
of [WSL or WSL
2](https://nickjanetakis.com/blog/a-linux-dev-environment-on-windows-with-wsl-2-docker-desktop-and-more).
That's because we're going to be running shell commands. You can always modify
these commands for PowerShell if you want.

#### Clone this repo anywhere you want and move into the directory

```sh
git clone https://github.com/stephenxp04/cg-assessment
cd cg-assessment

```

#### Copy an example .env file because the real one is git ignored

```sh
cp .env.example .env
```

#### Build everything

_The first time you run this it's going to take 5-10 minutes depending on your
internet connection speed and computer's hardware specs. That's because it's
going to download a few Docker images and build the Ruby + Yarn dependencies._

```sh
docker compose up --build
```

Now that everything is built and running we can treat it like any other Rails
app.

#### Setup the initial database

```sh
# You can run this from a 2nd terminal.
./run rails db:setup
```

_We'll go over that `./run` script in a bit!_

#### Check it out in a browser

Visit <http://localhost:8000> in your favorite browser.

#### Running the test suite

```sh
# You can run this from the same terminal as before.
./run test
```

You can also run `./run test -b` with does the same thing but builds your JS
and CSS bundles. This could come in handy in fresh environments such as CI
where your assets haven't changed and you haven't visited the page in a
browser.

#### Stopping everything

```sh
# Stop the containers and remove a few Docker related resources associated to this project.
docker compose down
```

You can start things up again with `docker compose up` and unlike the first
time it should only take seconds.

#### `run`

You can run `./run` to get a list of commands and each command has
documentation in the `run` file itself.

It's a shell script that has a number of functions defined to help you interact
with this project. It's basically a `Makefile` except with [less
limitations](https://nickjanetakis.com/blog/replacing-make-with-a-shell-script-for-running-your-projects-tasks).
For example as a shell script it allows us to pass any arguments to another
program.

This comes in handy to run various Docker commands because sometimes these
commands can be a bit long to type. Feel free to add as many convenience
functions as you want. This file's purpose is to make your experience better!

_If you get tired of typing `./run` you can always create a shell alias with
`alias run=./run` in your `~/.bash_aliases` or equivalent file. Then you'll be
able to run `run` instead of `./run`._

#### Writing unit and integration tests

Initialize RSpec in your Rails project:
./run rails generate rspec:install

Write tests:
/spec/controller/_
/spec/models/_
/spec/services/_
/spec/system/_

To run your tests, use the following command:
./run cmd bundle exec rspec

#### Side Notes

These are documentations for own purpose to explain and understand what the dependencies do

Puma:
Puma is a web server for Ruby applications. It's designed to be fast and lightweight, capable of handling multiple requests concurrently. In a Rails application, Puma serves as the interface between your Rails app and the web. It receives HTTP requests, passes them to your Rails app, and then sends the responses back to the clients.
Sidekiq:
Sidekiq is a background job processing system for Ruby. It uses Redis to store job information and manages worker processes to execute these jobs asynchronously. This is useful for tasks that are time-consuming or don't need to be performed immediately, such as sending emails, processing uploads, or generating reports.
Action Cable: Rails' built-in WebSockets framework for real-time features.
ERB: Embedded Ruby, a templating system for generating dynamic content.
Hotwire Turbo: Enhances the speed of web applications by breaking pages into components.
StimulusJS: A modest JavaScript framework for adding behavior to HTML.

RSpec:

Purpose: RSpec is a testing framework for Ruby, used primarily for unit and integration testing.
Scope: It's used to test individual components of your application, such as models, controllers, and services.
Focus: RSpec tests the behavior of your code, not the user interface.

Capybara:

Purpose: Capybara is an acceptance test framework for web applications.
Scope: It simulates how a real user would interact with your application.
Focus: Capybara tests the user interface and how different parts of your application work together from a user's perspective.
