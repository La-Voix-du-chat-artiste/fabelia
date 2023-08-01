module ApplicationHelper
  include Pagy::Frontend

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

  private

  def nostr_client_url
    ENV.fetch('NOSTR_CLIENT_URL', 'https://snort.social')
  end
end
