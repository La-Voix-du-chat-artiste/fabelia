class ChatGPTCompleteService < ChatGPTService
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

  def system_prompt_for_mode
    chapter_options.chatgpt_full_story_system_prompt
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
    " Ensure the story is complete and have a real coherent ending. Also reply in JSON RFC 8259 compliant format as instructed. Respond in #{language_name} language only."
  end
end
