FactoryBot.define do
  factory :character do
    first_name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    biography { Faker::Lorem.paragraph }
  end
end
