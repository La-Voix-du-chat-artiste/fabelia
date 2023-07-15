require 'openai_chatgpt'

class ChatgptService < ApplicationService
  attr_reader :prompt, :model

  def initialize(prompt, model = 'gpt-3.5-turbo')
    @prompt = prompt
    @model = model
  end

  def call
    response = client.completions(
      messages: messages,
      model: model
    )

    JSON.parse(response.results.first.content)
  end

  def messages
    array = [
      { role: 'system', content: system_prompt }
    ]

    array << { role: 'user', content: prompt }

    array
  end

  def system_prompt
    <<~STRING.strip
      You act as a story book adventure narrator. The adventure should be progressive, chapter by chapter (three to five sentences) and written in french.

      Provide a RFC 8259 compliant JSON response following this format without deviation:

      #{json_format.to_json}
    STRING
  end

  private

  def json_format
    [
      {
        title: 'Chapter title',
        content: 'Chapter story narration',
        summary: 'Chapter summary separated by commas'
      },
      {
        title: 'Another chapter title',
        content: 'Another chapter story narration',
        summary: 'Another chapter summary separated by commas'
      }
    ]
  end

  def client
    @client ||= OpenaiChatgpt::Client.new(api_key: api_key)
  end

  def api_key
    Rails.application.credentials.chatgpt.api_key
  end
end
