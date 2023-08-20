FactoryBot.define do
  factory :chapter do
    summary { Faker::Lorem.sentence }

    story

    trait :published do
      published_at { 1.day.ago }
    end
  end
end
