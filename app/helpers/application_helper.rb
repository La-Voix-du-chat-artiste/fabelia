module ApplicationHelper
  include Pagy::Frontend

  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flashes', partial: 'flashes'
  end

  def nostr_client_chapter_url(chapter)
    "#{nostr_client_url}/e/#{chapter.nostr_identifier}"
  end

  def nostr_client_story_url(story)
    "#{nostr_client_url}/e/#{story.nostr_identifier}"
  end

  def select_options_for(klass, enum_name)
    enum = klass.send(enum_name)
    enum.keys.map { |k| [klass.human_enum_name(enum_name, k), k] }
  end

  def story_nostr_users_select_options(company)
    all_languages = I18nData.languages(I18n.locale)

    company.nostr_users.enabled.with_relays.with_attached_picture.map do |nostr_user|
      language = nostr_user.language.upcase

      [
        nostr_user.profile.identity,
        nostr_user.id,
        { 'data-html': <<~HTML }
          <div class="flex items-center gap-2">
            #{image_tag(nostr_user.picture_url, class: 'w-10 rounded-full')}
            <div class="flex flex-col items-start">
              <p>#{nostr_user.profile.identity}</p>
              <p class="text-gray-400 text-xs">#{all_languages[language].capitalize}</p>
            </div>
          </div>
        HTML
      ]
    end
  end

  def story_characters_select_options(company)
    company.characters.enabled.with_attached_avatar.map do |character|
      data_html = nil

      if character.avatar.attached?
        data_html = <<~HTML
          <div class="flex items-center gap-2">
            #{image_tag(url_for(character.avatar), class: 'w-12 h-12 object-cover rounded-full')}
            <div class="flex flex-col items-start">
              <p>#{character.full_name}</p>
              <p class="text-gray-400 text-xs">#{character.biography.truncate(80)}</p>
            </div>
          </div>
        HTML
      end

      [character.full_name, character.id, { 'data-html': data_html }]
    end
  end

  def story_places_select_options(company)
    company.places.enabled.with_attached_photo.map do |place|
      data_html = <<~HTML
        <div class="flex items-center gap-2">
          #{image_tag(place.photo_url, class: 'w-12 h-12 object-cover rounded-full')}
          <div class="flex flex-col items-start">
            <p>#{place.name}</p>
            <p class="text-gray-400 text-xs">#{place.description.truncate(80)}</p>
          </div>
        </div>
      HTML

      [place.name, place.id, { 'data-html': data_html }]
    end
  end

  def nostr_user_languages_select_options
    all_languages = I18nData.languages(I18n.locale)

    all_languages.map do |code, name|
      ["#{name.capitalize} (#{code})", code.downcase]
    end
  end

  def prompt_background_color(model)
    {
      'MediaPrompt' => 'bg-green-400/25 border-green-700 dark:bg-gray-800 dark:text-green-400 dark:border-green-600',
      'NarratorPrompt' => 'bg-blue-400/25 border-blue-700 dark:bg-gray-800 dark:text-blue-400 dark:border-blue-600',
      'AtmospherePrompt' => 'bg-orange-400/25 border-orange-700 dark:bg-gray-800 dark:text-orange-400 dark:border-orange-600'
    }[model.to_s]
  end

  private

  def nostr_client_url
    ENV.fetch('NOSTR_CLIENT_URL', 'https://snort.social')
  end
end
