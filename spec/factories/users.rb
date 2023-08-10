FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "john.doe#{n}@example.test" }

    password { 'password' }
    password_confirmation { password }
  end
end
