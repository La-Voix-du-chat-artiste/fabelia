FactoryBot.define do
  factory :chapter do
    summary { FFaker::Lorem.sentence }

    story

    trait :published do
      published_at { 1.day.ago }
      nostr_identifier { SecureRandom.hex }
    end
  end
end
