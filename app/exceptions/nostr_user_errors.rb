class NostrUserErrors < BaseErrors
  MissingAssociatedRelay = Class.new(self)
  MissingFavoriteRelay = Class.new(self)
  EmptyLightningNetworkAddress = Class.new(self)

  BotMissing = Class.new(self) do
    attr_reader :language

    def initialize(language:)
      super()

      @language = language
    end

    def message
      I18n.t(class_name, language: language, scope: i18n_scope)
    end
  end

  BotDisabled = Class.new(self) do
    attr_reader :nostr_user

    def initialize(nostr_user)
      super()

      @nostr_user = nostr_user
    end

    def message
      I18n.t(
        class_name,
        name: nostr_user.profile.identity,
        language: nostr_user.human_language,
        scope: i18n_scope
      )
    end
  end
end
