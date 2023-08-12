FactoryBot.define do
  factory :nostr_user do
    sequence(:private_key) { Faker::Crypto.sha256 }

    relays { create_list :relay, 3 }
  end
end
