FactoryBot.define do
  factory :place do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
