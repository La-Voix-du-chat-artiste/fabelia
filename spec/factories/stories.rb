FactoryBot.define do
  factory :story do
    summary { FFaker::Lorem.sentence }

    thematic
    nostr_user

    media_prompt
    narrator_prompt
    atmosphere_prompt

    trait :enabled do
      enabled { true }
    end

    trait :disabled do
      enabled { false }
    end

    trait :published do
      after(:create) do |story|
        create_list :chapter, 2, :published, story: story
      end
    end

    trait :ended do
      adventure_ended_at { 1.day.ago }
    end
  end
end
