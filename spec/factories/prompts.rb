FactoryBot.define do
  factory :prompt do
    title { Faker::Lorem.paragraph }
    body { Faker::Lorem.sentence }

    type { 'Prompt' }

    trait :archived do
      archived_at { 1.week.ago }
    end
  end

  factory :media_prompt, parent: :prompt, class: 'MediaPrompt' do
    type { 'MediaPrompt' }
  end

  factory :narrator_prompt, parent: :prompt, class: 'NarratorPrompt' do
    type { 'NarratorPrompt' }
  end

  factory :atmosphere_prompt, parent: :prompt, class: 'AtmospherePrompt' do
    type { 'AtmospherePrompt' }
  end
end
