require 'openai_chatgpt'

class ChatgptService < ApplicationService
  private

  def client
    @client ||= OpenaiChatgpt::Client.new(api_key: api_key)
  end

  def api_key
    Rails.application.credentials.chatgpt.api_key
  end
end
