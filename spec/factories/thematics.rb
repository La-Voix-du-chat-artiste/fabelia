FactoryBot.define do
  factory :thematic do
    name_fr { FFaker::Lorem.sentence }
    name_en { FFaker::Lorem.sentence }
    description_fr { FFaker::Lorem.paragraph }
    description_en { FFaker::Lorem.paragraph }
    identifier { FFaker::Lorem.word }
  end
end
