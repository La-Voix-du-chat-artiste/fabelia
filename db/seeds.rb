require 'open-uri'

puts 'Seeding settings...'

Setting.create!

puts 'Seeding users...'

%i[standard admin super_admin].each do |role|
  avatar = Faker::LoremFlickr.image(size: '300x300', search_terms: ['avatar'])

  User.create!(
    email: "#{role}@test.test",
    password: 'password',
    password_confirmation: 'password',
    role: role,
    avatar: {
      io: URI.parse(avatar).open,
      filename: 'user_avatar'
    }
  )
end

puts 'Seeding relays...'

relay = Relay.create!(
  url: 'ws://umbrel.local:4848',
  description: 'Testing relay'
)

puts 'Seeding nostr users...'

NostrUser.create!(
  private_key: ENV.fetch('NOSTR_USER_FR_PRIVATE_KEY', Faker::Crypto.sha256),
  language: :fr,
  relays: [relay]
)

NostrUser.create!(
  private_key: ENV.fetch('NOSTR_USER_EN_PRIVATE_KEY', Faker::Crypto.sha256),
  language: :en,
  relays: [relay]
)

puts 'Seeding thematics...'

thematics = [
  {
    identifier: 'escape_game',
    name_en: 'Escape Game',
    name_fr: 'Escape Game',
    description_en: "You wake up in a dark, closed room. Your objective is to find a solution to leave the place where you are.",
    description_fr: "Tu te réveilles dans une pièce sombre et fermée. Ton objectif est de trouver une solution pour quitter l'endroit où tu es."
  },
  {
    identifier: 'jungle',
    name_en: 'A walk into the jungle',
    name_fr: 'Bienvenue dans la Jungle',
    description_en: "The user wakes up on a beautiful jungle, he will explore this jungle.",
    description_fr: "L'utilisateur se réveille dans un jungle luxuriante, il va explorer cette jungle."
  },
  {
    identifier: 'sea',
    name_en: 'Sea adventure',
    name_fr: 'Aventure maritime',
    description_en: 'A sea adventure with lots of twists and exploration, accross ocean.',
    description_fr: "Aventure remplie de rebondissement et pleine d'exploration, à traverse les mers."
  },
  {
    identifier: 'city',
    name_en: 'In the city',
    name_fr: 'En ville',
    description_en: 'An adventure with lots of twists and exploration, accross the city.',
    description_fr: "Une aventure remplie de rebondissement et pleine d'exploration, à travers la ville."
  },
  {
    identifier: 'space',
    name_en: 'Space odyssey',
    name_fr: "Odyssée de l'espace",
    description_en: 'A Space odyssey adventure with lots of twists and exploration, in space.',
    description_fr: "Aventure Odyssée dans l'espace remplie de rebondissement et pleine d'exploration, à traverse l'univers."
  },
  {
    identifier: 'garden',
    name_en: 'Accross gardens',
    name_fr: 'A travers les jardins',
    description_en: 'A walk accross gardens full of beautiful plants and flowers.',
    description_fr: 'Ballade à travers des jardins pleine de plantes luxuriantes et de fleurs.'
  }
]

Thematic.insert_all(thematics)
