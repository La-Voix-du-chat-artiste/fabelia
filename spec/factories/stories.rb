FactoryBot.define do
  factory :story do
    traits_for_enum :mode
    traits_for_enum :publication_rule

    thematic
    nostr_user
  end
end
