class ChatGPTCompleteService < ChatGPTService
  attr_reader :prompt, :language, :story, :model

  def initialize(prompt, language, story, model = 'gpt-3.5-turbo')
    @prompt = prompt
    @language = language
    @story = story
    @model = model
  end

  def call
    response = client.completions(
      messages: messages,
      model: model
    )

    JSON.parse(response.results.first.content)
  end

  private

  def messages
    array = [
      { role: 'system', content: system_prompt }
    ]

    array << { role: 'user', content: prompt + reminder }

    array
  end

  def prompt_instance
    @prompt_instance ||= Prompts::FullStoryPrompt.new(story)
  end

  def system_prompt
    prompt_instance.call
  end

  def reminder
    prompt_instance.reminder
  end
end
