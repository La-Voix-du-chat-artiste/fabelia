require 'openai_chatgpt'

class ChatgptService < ApplicationService
  private

  def client
    @client ||= OpenaiChatgpt::Client.new(api_key: api_key)
  end

  def api_key
    Rails.application.credentials.chatgpt.api_key
  end

  def minimum_chapters_count
    chapter_options.minimum_chapters_count
  end

  def maximum_chapters_count
    chapter_options.maximum_chapters_count
  end

  def chapter_options
    @chapter_options ||= Setting.first.chapter_options
  end

  def language_name
    I18nData.languages(:en)[language.upcase]
  end

  def system_prompt
    prompt = system_prompt_for_mode
             .gsub('{{language}}', language_name)
             .gsub('{{minimum_chapters_count}}', minimum_chapters_count.to_s)
             .gsub('{{maximum_chapters_count}}', maximum_chapters_count.to_s)

    prompt + response_format
  end

  def response_format
    <<~STRING.strip
      Provide a RFC 8259 compliant JSON response following this format without deviation:

      #{json_format.to_json}
    STRING
  end
end
