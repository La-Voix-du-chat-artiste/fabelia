class StoryOption < Option
  attribute :chatgpt_full_story_system_prompt, :string
  attribute :chatgpt_dropper_story_system_prompt, :string
  attribute :stable_diffusion_prompt, :string
  attribute :stable_diffusion_negative_prompt, :string
  attribute :read_as_pdf, :boolean, default: true
end
