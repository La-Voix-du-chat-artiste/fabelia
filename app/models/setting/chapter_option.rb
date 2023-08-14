class Setting
  class ChapterOption
    include StoreModel::Model

    MINIMUM_CHAPTERS_COUNT = 4
    MAXIMUM_CHAPTERS_COUNT = 10
    STABLE_DIFFUSION_PROMPT = 'Very very beautiful, elegant, highly detailed, realistic, depth'.freeze
    CHATGPT_FULL_STORY_SYSTEM_PROMPT = <<~PROMPT.strip.freeze
      You act as a story book adventure narrator. The adventure should be epic with elaborated scenario and plot twist. Make chapter from around ten paragraphs each, only in {{language}} language. For each chapter, choose a list of two options and then choose randomly one to be the prompt of the next chapter. Ensure returned chapters array contains between {{minimum_chapters_count}} and {{maximum_chapters_count}} only. Ensure the story is complete and have a real coherent ending.

      Provide a RFC 8259 compliant JSON response following this format without deviation:
    PROMPT

    CHATGPT_DROPPER_STORY_SYSTEM_PROMPT = <<~PROMPT.strip.freeze
      You act as a story book adventure narrator. The adventure should be progressive, generated one chapter at a time with a set of proposed options to continue the adventure. You reply in {{language}} only. Use "adventure_ended" boolean to inform that the story is considered as completed when the adventure before chapter {{maximum_chapters_count}}. Ensure the story has a real coherent ending.
    PROMPT

    attribute :minimum_chapters_count, :integer,
              default: MINIMUM_CHAPTERS_COUNT
    attribute :maximum_chapters_count, :integer,
              default: MAXIMUM_CHAPTERS_COUNT
    attribute :chatgpt_full_story_system_prompt, :string,
              default: CHATGPT_FULL_STORY_SYSTEM_PROMPT
    attribute :chatgpt_dropper_story_system_prompt, :string,
              default: CHATGPT_DROPPER_STORY_SYSTEM_PROMPT
    attribute :stable_diffusion_prompt, :string,
              default: STABLE_DIFFUSION_PROMPT

    validates :minimum_chapters_count,
              presence: true,
              numericality: {
                greater_than_or_equal_to: MINIMUM_CHAPTERS_COUNT,
                less_than_or_equal_to: :maximum_chapters_count
              }

    validates :maximum_chapters_count,
              presence: true,
              numericality: {
                less_than_or_equal_to: MAXIMUM_CHAPTERS_COUNT,
                greater_than_or_equal_to: :minimum_chapters_count
              }

    validates :stable_diffusion_prompt, presence: true
    validates :chatgpt_full_story_system_prompt, presence: true
    validates :chatgpt_dropper_story_system_prompt, presence: true
  end
end
