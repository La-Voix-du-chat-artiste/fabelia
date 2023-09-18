module Prompts
  class DropperStoryPrompt < SystemPrompt
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
        Reply in JSON RFC 8259 compliant format as instructed, respond in #{language} language only.
      BODY
    end

    private

    def default_system_prompt
      <<~BODY
        The adventure should be progressive, generated one chapter at a time with a set of proposed options to continue the adventure.
        You reply in {{language}} only.
        Use "adventure_ended" boolean to inform that the story is considered as completed when the adventure reach chapter {{maximum_chapters_count}}.
        Ensure the story has a real coherent ending.
      BODY
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
  end
end
