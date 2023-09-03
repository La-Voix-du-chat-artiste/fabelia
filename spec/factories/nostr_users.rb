FactoryBot.define do
  factory :nostr_user do
    name { Faker::Name.name }
    language { I18nData.languages.keys.sample }
    sequence(:private_key) { Faker::Crypto.sha256 }

    relays { create_list :relay, 3 }
  end
end
