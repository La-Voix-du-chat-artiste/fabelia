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

if ENV.fetch('NOSTR_USER_FR_PRIVATE_KEY', nil).present?
  nostr_user = NostrUser.create!(
    private_key: ENV.fetch('NOSTR_USER_FR_PRIVATE_KEY'),
    language: :fr,
    relays: [relay],
    mode: :imported
  )
  NostrAccounts::ImportProfile.call(nostr_user)
else
  NostrUser.create!(
    display_name: Faker::Superhero.name,
    private_key: Faker::Crypto.sha256,
    language: :fr,
    relays: [relay],
    mode: :generated
  )
end

if ENV.fetch('NOSTR_USER_EN_PRIVATE_KEY', nil).present?
  nostr_user = NostrUser.create!(
    private_key: ENV.fetch('NOSTR_USER_EN_PRIVATE_KEY'),
    language: :en,
    relays: [relay],
    mode: :imported
  )
  NostrAccounts::ImportProfile.call(nostr_user)
else
  NostrUser.create!(
    display_name: Faker::Superhero.name,
    private_key: Faker::Crypto.sha256,
    language: :en,
    relays: [relay],
    mode: :generated
  )
end

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

puts 'Seeding characters...'

characters = [
  {
    first_name: 'Jean',
    last_name: 'De la Fontaine',
    biography: 'A renowned French poet and fabulist, Jean de la Fontaine is best known for his collection of fables, which combine imaginative storytelling with moral lessons. Exploring his creative process, his influential works, and his impact on French literature would offer a window into the life of a celebrated writer of the 17th century.',
    avatar: {
      io: URI.parse('https://wikiless.org/media/wikipedia/commons/thumb/d/dd/Jean_de_La_Fontaine.PNG/520px-Jean_de_La_Fontaine.PNG').open,
      filename: 'character_avatar.png'
    }
  },
  {
    first_name: 'Satoshi',
    last_name: 'Nakamoto',
    biography: "The enigmatic and pseudonymous creator of Bitcoin and the concept of blockchain technology, Satoshi Nakamoto's true identity remains unknown. Delving into the origins of Bitcoin, analyzing Nakamoto's motivations, and examining the global impact of decentralized cryptocurrencies would present a fascinating exploration of the future of finance and technology.",
    avatar: {
      io: URI.parse('https://wikiless.org/media/wikipedia/commons/thumb/7/77/Satoshi_Nakamoto.jpg/520px-Satoshi_Nakamoto.jpg').open,
      filename: 'character_avatar.png'
    }
  },
  {
    first_name: 'Zinedine',
    last_name: 'Zidane',
    biography: "A legendary French footballer and coach, Zinedine Zidane's incredible skill, elegance, and success on the field have made him one of the greatest players of all time. Unpacking his rise from humble beginnings, his key moments in football history, and his transition into coaching would provide a comprehensive look at a football icon's life and legacy.",
    avatar: {
      io: URI.parse('https://wikiless.org/media/wikipedia/commons/thumb/4/4b/Zinedine_Zidane_2015_%28cropped%29.jpg/500px-Zinedine_Zidane_2015_%28cropped%29.jpg').open,
      filename: 'character_avatar.png'
    }
  },
  {
    first_name: 'Spider-Man',
    biography: "Spider-Man, also known as Peter Parker, is one of Marvel's most beloved and iconic superheroes. Peter Parker, an intelligent and shy high school student from Queens, New York, gained his arachnid-like powers after being bitten by a radioactive spider during a science experiment. This transformative event bestowed him with incredible abilities, including superhuman strength, agility, and the ability to cling to walls. Inspired by his uncle's tragic death, Peter takes on the mantle of Spider-Man, dedicating himself to using his powers responsibly and protecting the innocent. At first, Peter's life as a superhero and his personal life clash. Juggling his studies, part-time jobs, and crime-fighting duties becomes an immense challenge. However, he finds solace in the support of his Aunt May and his best friend, Harry Osborn. Another important figure in his life is his love interest, Mary Jane Watson, a spirited and charismatic classmate who eventually becomes a source of strength and emotional support for Peter. Over the years, Spider-Man has encountered a vast array of rogues and villains in his crime-fighting endeavors, including the sinister Green Goblin, the symbiotic Venom, and the brilliant but deranged Doctor Octopus. These intense confrontations test Spider-Man's physical and mental fortitude while shaping him into a formidable and resilient hero. Even when facing personal challenges and tragedy, such as the loss of loved ones and strained relationships, Spider-Man remains a symbol of hope and perseverance. He embodies the values of responsibility, using his powers to protect the innocent, and striving to make a positive difference in his community. Throughout his comic book series, numerous adaptations in films, TV shows, and video games, Spider-Man's popularity has endured for generations. He continues to be a relatable and inspiring character, showcasing the triumph of the ordinary individual overcoming adversity and embracing their true potential. Spider-Man's journey as a superhero is a testament to the enduring power of courage, resilience, and the ability to rise above one's limitations. With great power comes great responsibility, and Spider-Man exemplifies the spirit of a selfless hero who fights to make the world a better place.",
    avatar: {
      io: URI.parse('https://whatsondisneyplus.com/wp-content/uploads/2022/12/spiderman.png.webp').open,
      filename: 'character_avatar.png'
    }
  }
]

characters.each do |character|
  Character.create!(character)
end


puts 'Seeding places...'

places = [
  {
    name: "The Great Wall of China",
    description: "Spanning over 13,000 miles, this ancient architectural wonder offers breathtaking views and a glimpse into China's rich history.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['great-wall-china'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "Machu Picchu, Peru",
    description: "Nestled high in the Andes mountains, this mystical Incan city is renowned for its stunning ruins and panoramic vistas.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['machu-picchu-peru'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Taj Mahal, India",
    description: "A UNESCO World Heritage Site, this marble mausoleum is an awe-inspiring symbol of love, featuring intricate architecture and enchanting gardens.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['taj-mahal-india'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Pyramids of Giza, Egypt",
    description: "These iconic structures date back to ancient times and hold many secrets, attracting visitors with their grandeur and mystical allure.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['giza-pyramids-egypt'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Colosseum, Italy",
    description: "In the heart of Rome, this colossal amphitheater is a symbol of the ancient Roman Empire, offering visitors a glimpse into the world of gladiator battles.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['colosseum-italy'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Great Barrier Reef, Australia",
    description: "A natural wonder of the world, this underwater paradise is home to thousands of marine species and mesmerizing coral formations.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['barrier-reef-australia'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Statue of Liberty, United States",
    description: "Standing tall in New York Harbor, this iconic monument serves as a symbol of freedom and democracy, welcoming visitors to the land of opportunity.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['statue-of-liberty-usa'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Serengeti National Park, Tanzania",
    description: "Known for its vast savannahs and annual wildebeest migration, this renowned wildlife sanctuary offers unforgettable safari experiences.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['serengeti-national-park-tanzania'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Angkor Wat, Cambodia",
    description: "A UNESCO World Heritage Site, this magnificent temple complex features stunning architecture and is the largest religious monument in the world.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['angkor-wat-cambodia'])).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Eiffel Tower, France",
    description: "A timeless symbol of Paris, this monumental iron lattice tower offers stunning views of the city and is an emblem of architectural innovation.",
    photo: {
      io: URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: ['eiffel-tower-france'])).open,
      filename: 'place_photo.png'
    }
  }
]

places.each do |place|
  Place.create!(place)
end
