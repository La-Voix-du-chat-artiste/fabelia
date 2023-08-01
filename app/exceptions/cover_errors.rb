class CoverErrors < BaseErrors
  NSFWDetected = Class.new(self) do
    def initialize(prompt, prediction)
      super()

      @prompt = prompt
      @prediction = prediction
    end

    def message
      I18n.t(class_name, prompt: @prompt, prediction: @prediction, scope: i18n_scope)
    end
  end
end
