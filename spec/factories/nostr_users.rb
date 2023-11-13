FactoryBot.define do
  factory :nostr_user do
    display_name { FFaker::Name.name }
    language { I18nData.languages.keys.sample }
    sequence(:private_key) { FFaker::Crypto.sha256 }

    relays { create_list :relay, 3 }
  end
end
