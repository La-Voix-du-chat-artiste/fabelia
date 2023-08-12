FactoryBot.define do
  factory :nostr_user do
    sequence(:private_key) { Faker::Crypto.sha256 }
    language { I18nData.languages.keys.sample }

    relays { create_list :relay, 3 }
  end
end
