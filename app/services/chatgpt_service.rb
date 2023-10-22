require 'openai_chatgpt'

class ChatGPTService < ApplicationService
  private

  def client
    @client ||= OpenaiChatgpt::Client.new(api_key: api_key)
  end

  def api_key
    ENV.fetch('CHATGPT_API_KEY', nil)
  end
end
