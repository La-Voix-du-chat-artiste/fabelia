FactoryBot.define do
  factory :company do
    name { FFaker::Company.name }

    after :create do |company|
      create :setting, company: company
    end
  end
end
