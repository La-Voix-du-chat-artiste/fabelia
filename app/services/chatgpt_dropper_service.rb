class ChatgptDropperService < ChatgptService
  attr_reader :prompt, :story, :model

  def initialize(prompt, story = nil, model = 'gpt-3.5-turbo')
    @prompt = prompt
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

  def messages
    array = [
      { role: 'system', content: system_prompt }
    ]

    chapters.each do |chapter|
      array << { role: 'user', content: chapter.prompt }
      array << { role: 'assistant', content: chapter.content }
    end

    array << { role: 'user', content: prompt + reminder }

    array
  end

  def system_prompt
    <<~STRING.strip
      You act as a story book adventure narrator. The adventure should be progressive, generated one chapter at a time with a set of proposed options to continue the adventure. You reply in french only. Use "adventure_ended" boolean to inform that the story is considered as completed.

      Provide a RFC 8259 compliant JSON response following this format without deviation:

      #{json_format.to_json}
    STRING
  end

  private

  def json_format
    {
      title: 'Chapter title',
      content: 'Chapter story narration',
      summary: 'Chapter, summary, commas, separated, english',
      options: [
        'First option',
        'Second option',
        'Third option'
      ],
      adventure_ended: true
    }
  end

  def chapters
    return [] if story.nil?

    story.chapters.last(8)
  end

  def reminder
    "\n(reply in JSON RFC 8259 compliant format as instructed)"
  end
end
