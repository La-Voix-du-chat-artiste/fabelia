module Prompts
  class FullStoryPrompt < SystemPrompt
    attr_reader :story

    def initialize(story)
      @story = story
    end

    def call
      (
        default_system_prompt_with_replaced_variables +
        narrator_prompt + narrator_negative_prompt +
        atmosphere_prompt + atmosphere_negative_prompt +
        characters_prompt + places_prompt +
        response_format
      ).tr("\n", ' ')
    end

    def reminder
      <<~BODY
        Ensure the story is complete and have a real coherent ending. Also reply in JSON RFC 8259 compliant format as instructed. Respond in #{language} language only.
      BODY
    end

    private

    def default_system_prompt
      <<~BODY
        The adventure should be in {{language}} only.
        For each chapter, choose a list of two options and then choose randomly one to be the prompt of the next chapter.
        Ensure story contains between minimum {{minimum_chapters_count}} and maximum {{maximum_chapters_count}} chapters.
        Ensure the story is complete and have a real coherent ending.
      BODY
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
  end
end
