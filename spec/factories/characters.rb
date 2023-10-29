FactoryBot.define do
  factory :character do
    first_name { FFaker::Name.name }
    last_name { FFaker::Name.last_name }
    biography { FFaker::Lorem.paragraph }

    company
  end
end
