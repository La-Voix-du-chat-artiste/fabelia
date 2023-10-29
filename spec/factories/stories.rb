FactoryBot.define do
  factory :story do
    title { FFaker::Lorem.sentence }
    summary { FFaker::Lorem.sentence }

    company

    before :create do |story|
      story.thematic = create :thematic, company: story.company
      story.nostr_user = create :nostr_user, company: story.company

      story.media_prompt = create :media_prompt, company: story.company
      story.narrator_prompt = create :narrator_prompt, company: story.company
      story.atmosphere_prompt = create :atmosphere_prompt, company: story.company
    end

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
