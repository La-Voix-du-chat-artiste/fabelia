class ThematicErrors < BaseErrors
  ThematicDisabled = Class.new(self) do
    attr_reader :thematic

    def initialize(thematic)
      super()

      @thematic = thematic
    end

    def message
      I18n.t(class_name, name: thematic.name, scope: i18n_scope)
    end
  end
end
