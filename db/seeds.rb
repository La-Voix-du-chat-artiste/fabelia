require 'open-uri'

puts 'Seeding users...'

user = User.create!(
  email: 'admin@test.test',
  password: 'password',
  password_confirmation: 'password'
)

avatar = Faker::LoremFlickr.image(size: '300x300', search_terms: ['avatar'])
user.avatar.attach(
  io: URI.parse(avatar).open,
  filename: 'user_avatar'
)
