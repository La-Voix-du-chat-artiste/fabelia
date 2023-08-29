<p align="center">
  <img src="public/banner.png" alt="Fabelia banner"/>
</p>

# <img align="left" width="50" src="public/logo.png" alt="Fabelia logo" />&nbsp; Fabelia

Fabelia is a Nostr bot that publish AI generated stories to relays.

[![Ruby on Rails CI](https://github.com/La-Voix-du-chat-artiste/fabelia/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/La-Voix-du-chat-artiste/fabelia/actions/workflows/rubyonrails.yml)

## AI tools

Fabelia rely currently on two AI to build stories:

- [chatGPT](https://openai.com/chatgpt) : generate the story
- [StableDiffusion](https://replicate.com/stability-ai/stable-diffusion) : generate stories and chapters cover

## Development tools

Fabelia is built with the following technologies:

- [Ruby on Rails](https://rubyonrails.org)
- [PostgreSQL](https://www.postgresql.org)
- [Tailwind CSS](https://tailwindcss.com)
- [Docker](https://www.docker.com)

To setup the development project, follow these instructions:

- Clone the project
- Go to project folder: `$ cd fabelia`
- Run `$ docker-compose up -d` to start PostgreSQL and Redis containers
- Add ChatGPT and Replicate API keys as ENV vars:
  
  ```bash
  # .env
  CHATGPT_API_KEY=my_chatgpt_api_key
  REPLICATE_API_KEY=my_replicate_api_key
  ```

- Run `$ bin/rails db:encryption:init` to generate encryption keys and paste these values to corresponding ENV vars:

  ```bash
  # .env
  ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=my_primary_key
  ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=my_deterministic_key
  ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=my_key_derivation_salt
  ```

  Note: this step is required as Nostr private key accounts are encrypted in DB

- Install [ngrok](https://ngrok.com) command to allow Replicate webhooks to get back to Fabelia

- Run `$ ngrok http 3000`
- Copy the ngrok provided URL to your `HOST` env variable:
  ```shell
  # .env
  HOST=ngrok_host
  ```

- Run `$ bundle install`
- Run `$ bin/rails db:migrate db:seed`
- Finally launch the Rails server with `$ bin/dev` !

Note: To be able to publish a story, you must configure a `NostrUser` with a private key and a relay URL at http://localhost:3000/nostr_users

## Rake tasks

Fabelia provide several rake tasks to easily manage stories publications:

- `$ bin/rails stories:publish_next_chapter`:
  Publish the next chapter of the current active story for any configured `NostrUser` languages. If the story is ended, a new one will be generated.
- `$ bin/rails stories:publish_all_chapters`:
  Publish all remaining chapters of the current active story for any configured `NostrUser` languages. If the story is ended, new story won't be generated
- `$ bin/rails stories:generate_and_publish_full_story[<language>]`:
  Generate and publish a full story for a given language.

Note: for a complete automation of stories publication, configure a CRON job that will run any of these tasks to a specified recurrence.

## Roadmap

Fabelia is still in early development, here are some of planned enhancements:

- [x] Use `action_policy` to protect controller actions
- [ ] Filter rake task adding more options (language, thematics)
- [ ] Document code
- [ ] Add `RSpec` tests
- [x] Generate different version of images with ActiveStorage variants
- [ ] Refactor duplicated code
- [ ] Extract texts to I18n
- [ ] When removing a story from interface, send a deletion event to Nostr relays
- [ ] Add an option in interface to ask if adventure should be published immediately
- [ ] Improve design rendering and responsive
- [x] Handle more relays configuration to published to
- [ ] Switch IA tools to open source equivalent
- [ ] Add CI actions (Rubocop, RSpec)
- [ ] Fix more hidden bugs ! 🤓

## Sponsoring

If you appreciate this project and would like to support developpers team, you can:

- subscribe to an "Expresso" plan on [Flownaely Café](https://flownaely.cafe) ☕
- send some satochis to **bc1qkaq059gxysmrvsuv2ut7cnjnvec557dep5zjgk** address
  
  ![Bitcoin address](public/bc1qkaq059gxysmrvsuv2ut7cnjnvec557dep5zjgk.png)
