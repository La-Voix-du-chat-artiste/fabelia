FactoryBot.define do
  factory :place do
    name { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }

    company
  end
end
