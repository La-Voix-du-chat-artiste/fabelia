<p align="center">
  <img src="public/banner.png" alt="Fabelia banner"/>
</p>

# <img align="left" width="50" src="public/logo.png" alt="Fabelia logo" />&nbsp;Fabelia

Fabelia is a Nostr bot that publish AI generated stories to relays.


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
- Run `$ bin/rails credentials:edit` to setup your ChatGPT and Replicate API keys as credentials:

  ```yaml
  # credentials
  chatgpt:
    api_key: my_api_key

  replicate:
    api_key: my_api_key
  ```

- Run `$ bin/rails db:encryption:init` and paste the output to credentials:

  ```yaml
  # credentials

  # ... previous credentials

  active_record_encryption:
    primary_key: my_primary_key
    deterministic_key: my_deterministic_key
    key_derivation_salt: my_key_derivation_salt
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

## Roadmap

Fabelia is still in early development, here are some of planned enhancements:

- [ ] Use `action_policy` to protect controller actions
- [ ] Filter rake task adding more options (language, thematics)
- [ ] Document code
- [ ] Add `RSpec` tests
- [ ] Generate different version of images with ActiveStorage variants
- [ ] Refactor duplicated code
- [ ] Extract texts to I18n
- [ ] When removing a story from interface, send a deletion event to Nostr relays
- [ ] Add an option in interface to ask if adventure should be published immediately
- [ ] Improve design rendering
- [ ] Handle more relays configuration to published to
- [ ] Switch IA tools to open source equivalent
