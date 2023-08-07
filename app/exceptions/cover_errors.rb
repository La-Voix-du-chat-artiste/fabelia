class CoverErrors < BaseErrors
  NSFWDetected = Class.new(self) do
    attr_reader :model

    def initialize(prompt, prediction, model)
      super()

      @prompt = prompt
      @prediction = prediction
      @model = model
    end

    def message
      I18n.t(class_name, prompt: @prompt, prediction: @prediction, scope: i18n_scope)
    end
  end
end
