class Setting
  class ChapterOption
    include StoreModel::Model

    MINIMUM_CHAPTERS_COUNT = 4
    MAXIMUM_CHAPTERS_COUNT = 10
    MINIMUM_POLL_SATS = 42
    MAXIMUM_POLL_SATS = 420
    PUBLISH_PREVIOUS = false
    STABLE_DIFFUSION_PROMPT = 'Hyper realistic, epic composition, cinematic, landscape vista photography by Carr Clifton & Galen Rowell, Landscape veduta photo by Dustin Lefevre & tdraw, detailed landscape painting by Ivan Shishkin, rendered in Enscape, Miyazaki, Nausicaa Ghibli, 4k detailed post processing, unreal engine'.freeze
    STABLE_DIFFUSION_NEGATIVE_PROMPT = 'Deformed, blurry, bad anatomy, disfigured, poorly drawn face, mutation, mutated, extra limb, ugly, poorly drawn hands, missing limb, blurry, floating limbs, disconnected limbs, malformed hands, blur, out of focus, long neck, long body, ((((mutated hands and fingers)))), (((out of frame)))'.freeze
    CHATGPT_FULL_STORY_SYSTEM_PROMPT = <<~PROMPT.strip.freeze
      You act as a story book adventure narrator. The adventure should be epic with elaborated scenario and plot twist. Make chapter from around ten paragraphs each, only in {{language}} language. For each chapter, choose a list of two options and then choose randomly one to be the prompt of the next chapter. Ensure returned chapters array contains between {{minimum_chapters_count}} and {{maximum_chapters_count}} only. Ensure the story is complete and have a real coherent ending.
    PROMPT

    CHATGPT_DROPPER_STORY_SYSTEM_PROMPT = <<~PROMPT.strip.freeze
      You act as a story book adventure narrator. The adventure should be progressive, generated one chapter at a time with a set of proposed options to continue the adventure. You reply in {{language}} only. Use "adventure_ended" boolean to inform that the story is considered as completed when the adventure reach chapter {{maximum_chapters_count}}. Ensure the story has a real coherent ending.
    PROMPT

    attribute :minimum_chapters_count, :integer,
              default: MINIMUM_CHAPTERS_COUNT
    attribute :maximum_chapters_count, :integer,
              default: MAXIMUM_CHAPTERS_COUNT
    attribute :minimum_poll_sats, :integer, default: MINIMUM_POLL_SATS
    attribute :maximum_poll_sats, :integer, default: MAXIMUM_POLL_SATS
    attribute :publish_previous, :boolean, default: PUBLISH_PREVIOUS
    attribute :chatgpt_full_story_system_prompt, :string,
              default: CHATGPT_FULL_STORY_SYSTEM_PROMPT
    attribute :chatgpt_dropper_story_system_prompt, :string,
              default: CHATGPT_DROPPER_STORY_SYSTEM_PROMPT
    attribute :stable_diffusion_prompt, :string,
              default: STABLE_DIFFUSION_PROMPT
    attribute :stable_diffusion_negative_prompt, :string,
              default: STABLE_DIFFUSION_NEGATIVE_PROMPT

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

    validates :minimum_poll_sats,
              presence: true,
              numericality: {
                greater_than_or_equal_to: MINIMUM_POLL_SATS,
                less_than_or_equal_to: :maximum_poll_sats
              }

    validates :maximum_poll_sats,
              presence: true,
              numericality: {
                less_than_or_equal_to: MAXIMUM_POLL_SATS,
                greater_than_or_equal_to: :minimum_poll_sats
              }

    validates :publish_previous, allow_blank: false, inclusion: [true, false]

    def publish_previous=(value)
      super(value.to_bool)
    end
  end
end
