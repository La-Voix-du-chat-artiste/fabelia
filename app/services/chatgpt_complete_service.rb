class ChatgptCompleteService < ChatgptService
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
      You act as a story book adventure narrator. The adventure should be epic with elaborated scenario and plot twist. Make chapter from around ten paragraphs each only in french language.

      Provide a RFC 8259 compliant JSON response following this format without deviation:

      #{json_format.to_json}
    STRING
  end

  private

  def json_format
    {
      title: 'Adventure title',
      chapters: [
        {
          title: 'Chapter title',
          content: 'Chapter story narration',
          summary: 'Chapter, summary, commas, separated, english'
        },
        {
          title: 'Another chapter title',
          content: 'Another chapter story narration',
          summary: 'another, chapter, summary, commas, separated, english'
        }
      ]
    }
  end
end
