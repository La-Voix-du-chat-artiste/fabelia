FactoryBot.define do
  factory :place do
    name { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
  end
end
