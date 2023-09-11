class ChatGPTSummaryService < ChatGPTService
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

    response.results.first.content
  end

  def messages
    array = [
      { role: 'system', content: system_prompt }
    ]

    array << { role: 'user', content: user_prompt + reminder }

    array
  end

  def system_prompt
    <<~STRING.strip
      You act as a storyteller that write stories summaries.
    STRING
  end

  def user_prompt
    <<~STRING.strip
      Make a summary of the prompt using maximum ten descriptive words (eg: "blue sky", "tree house", "flying bird", ...).
      Keywords must be translated in english comma separated from the given prompt.
      Removes any NSFW words that could be misinterpreted.

      Here is the prompt: #{prompt}

    STRING
  end

  def reminder
    'Reply only with a list of adjectives. Do not deviate from this instruction.'
  end
end
