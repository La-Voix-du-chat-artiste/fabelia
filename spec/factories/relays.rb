FactoryBot.define do
  factory :relay do
    sequence(:url) { |n| "wss://relay#{n}.test" }

    company
  end
end
