class ChatgptCompleteService < ChatgptService
  attr_reader :prompt, :language, :model

  def initialize(prompt, language, model = 'gpt-3.5-turbo')
    @prompt = prompt
    @language = language
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

  def system_prompt
    <<~STRING.strip
      You act as a story book adventure narrator. The adventure should be epic with elaborated scenario and plot twist. Make chapter from around ten paragraphs each, only in #{Story.human_enum_name(:language, language, locale: :en)}language. For each chapter, choose a list of two options and then choose randomly one to be the prompt of the next chapter.

      Provide a RFC 8259 compliant JSON response following this format without deviation:

      #{json_format.to_json}
    STRING
  end

  def json_format
    {
      title: 'Adventure title',
      chapters: [
        {
          title: 'Chapter title',
          content: 'Chapter story narration',
          summary: 'Chapter, summary, commas, separated, english',
          options: [
            'First option',
            'Second option',
            'Third option'
          ]
        },
        {
          title: 'Another chapter title',
          content: 'Another chapter story narration',
          summary: 'another, chapter, summary, commas, separated, english',
          options: [
            'Another first option',
            'Another second option',
            'Another third option'
          ]
        }
      ]
    }
  end

  def reminder
    'Ensure the story is complete and have a real coherent ending. Also reply in JSON RFC 8259 compliant format as instructed'
  end
end
