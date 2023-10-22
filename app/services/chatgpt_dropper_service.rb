class ChatGPTDropperService < ChatGPTService
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

    json = JSON.parse(response.results.first.content)

    return json if json['adventure_ended'].to_bool

    raise ChapterErrors::EmptyPollOptions if json['options'].blank?
    raise ChapterErrors::MissingPollOptions if json['options'].size < 2

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

  def prompt_instance
    @prompt_instance ||= Prompts::DropperStoryPrompt.new(story)
  end

  def system_prompt
    prompt_instance.call
  end

  def reminder
    prompt_instance.reminder
  end

  def chapters
    return [] if story.nil?

    story.chapters.not_draft.by_position.last(10)
  end
end
