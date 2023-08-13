FactoryBot.define do
  factory :thematic do
    name_fr { Faker::Lorem.sentence }
    name_en { Faker::Lorem.sentence }
    description_fr { Faker::Lorem.paragraph }
    description_en { Faker::Lorem.paragraph }
    identifier { Faker::Lorem.word }
  end
end
