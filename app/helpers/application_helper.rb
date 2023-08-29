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

    NostrUser.enabled.map do |nostr_user|
      language = nostr_user.language.upcase
      key = "#{nostr_user.profile.identity} (#{all_languages[language].capitalize})"

      [key, nostr_user.id]
    end
  end

  def nostr_user_languages_select_options
    all_languages = I18nData.languages(I18n.locale)

    all_languages.map do |code, name|
      ["#{name.capitalize} (#{code})", code]
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
