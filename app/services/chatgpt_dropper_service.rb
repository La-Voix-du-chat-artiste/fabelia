class ChatgptDropperService < ChatgptService
  attr_reader :prompt, :language, :story, :model

  def initialize(prompt, language, story = nil, model = 'gpt-3.5-turbo')
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

    json = JSON.parse(response.results.first.content)

    return json if json['adventure_ended'].to_bool

    raise ChapterErrors::EmptyPollOptions if json['options'].blank?
    raise ChapterErrors::MissingPollOptions if json['options'].size <= 1

    json
  end

  private

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

  def system_prompt_for_mode
    chapter_options.chatgpt_dropper_story_system_prompt
  end

  def json_format
    {
      story_title: 'Story title',
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

    story.chapters.by_position.last(8)
  end

  def reminder
    ' (reply in JSON RFC 8259 compliant format as instructed)'
  end
end
