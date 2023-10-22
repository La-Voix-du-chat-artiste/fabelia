class MediaPromptOption
  include StoreModel::Model

  NUM_INFERENCE_STEPS = 20

  attribute :num_inference_steps, :integer,
            default: NUM_INFERENCE_STEPS
end
