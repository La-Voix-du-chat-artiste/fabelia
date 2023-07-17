module ReplicateServices
  class Picture < BaseReplicate
    attr_reader :chapter, :prompt

    def initialize(chapter, prompt)
      @chapter = chapter
      @prompt = prompt
    end

    def call
      prediction = version.predict({
        prompt: prompt + default_keywords,
        num_inference_steps: 20
      }, webhook_url)

      chapter.update!(replicate_identifier: prediction.id)
    end
  end
end
