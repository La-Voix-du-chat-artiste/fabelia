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

  def story_nostr_users_select_options
    all_languages = I18nData.languages(I18n.locale)

    NostrUser.enabled.with_relays.with_attached_picture.map do |nostr_user|
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

  def story_characters_select_options
    Character.enabled.with_attached_avatar.map do |character|
      data_html = nil

      if character.avatar.attached?
        data_html = <<~HTML
          <div class="flex items-center gap-2">
            #{image_tag(url_for(character.avatar), class: 'w-10 h-10 object-cover rounded-full')}
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

  def nostr_user_languages_select_options
    all_languages = I18nData.languages(I18n.locale)

    all_languages.map do |code, name|
      ["#{name.capitalize} (#{code})", code.downcase]
    end
  end

  def highlight_code(json)
    json = json.gsub(',"', ",\n\"")
               .gsub('{"', "{\n\"")
               .gsub('"}', "\"\n}")
               .gsub('":', '": ')
               .gsub('true}', "true\n}")
               .gsub('false}', "false\n}")

    Pygments.highlight(json, lexer: :json)
  end

  private

  def nostr_client_url
    ENV.fetch('NOSTR_CLIENT_URL', 'https://snort.social')
  end
end
