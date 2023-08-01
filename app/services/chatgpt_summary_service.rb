class ChatgptSummaryService < ChatgptService
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

    array << { role: 'user', content: prompt }

    array
  end

  def system_prompt
    <<~STRING.strip
      Make an accurate and detailed response using maximum ten keywords adjective and nouns.
      Keywords must be english comma separated from the given prompt.
    STRING
  end
end
