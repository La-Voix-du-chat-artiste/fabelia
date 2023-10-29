require 'open-uri'

puts 'Seeding companies...'

logo = FFaker::Image.url(size: '300x300')

company = Company.create!(
  name: FFaker::Company.name,
  logo: {
    io: URI.parse(logo).open,
    filename: 'logo.png'
  }
)

puts 'Seeding settings...'

company.create_setting!

puts 'Seeding users...'

%i[standard admin super_admin].each do |role|
  avatar = FFaker::Avatar.image(size: '300x300')

  company.users.create!(
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

relay = company.relays.create!(
  url: 'ws://umbrel.local:4848',
  description: 'Self-hosted relay on Umbrel server'
)

puts 'Seeding nostr users...'

if ENV.fetch('NOSTR_USER_FR_PRIVATE_KEY', nil).present?
  nostr_user = company.nostr_users.create!(
    private_key: ENV.fetch('NOSTR_USER_FR_PRIVATE_KEY'),
    language: :fr,
    relays: [relay],
    mode: :imported
  )
  NostrServices::ImportProfile.call(nostr_user)
else
  nostr_user = company.nostr_users.create!(
    display_name: FFaker::Internet.user_name,
    private_key: FFaker::Crypto.sha256,
    language: :fr,
    lud16: 'bot.fr@sendme.sats',
    relays: [relay],
    mode: :generated
  )

  NostrPublisher::Profile.call(nostr_user)
end

if ENV.fetch('NOSTR_USER_EN_PRIVATE_KEY', nil).present?
  nostr_user = company.nostr_users.create!(
    private_key: ENV.fetch('NOSTR_USER_EN_PRIVATE_KEY'),
    language: :en,
    relays: [relay],
    mode: :imported
  )
  NostrServices::ImportProfile.call(nostr_user)
else
  nostr_user = company.nostr_users.create!(
    display_name: FFaker::Internet.user_name,
    private_key: FFaker::Crypto.sha256,
    language: :en,
    lud16: 'bot.en@sendme.sats',
    relays: [relay],
    mode: :generated
  )

  NostrPublisher::Profile.call(nostr_user)
end

puts 'Seeding thematics...'

thematics = [
  {
    name_en: 'Escape Game',
    name_fr: 'Escape Game',
    description_en: "You wake up in a dark, closed room. Your objective is to find a solution to leave the place where you are.",
    description_fr: "Tu te réveilles dans une pièce sombre et fermée. Ton objectif est de trouver une solution pour quitter l'endroit où tu es."
  },
  {
    name_en: 'A walk into the jungle',
    name_fr: 'Bienvenue dans la Jungle',
    description_en: "The user wakes up on a beautiful jungle, he will explore this jungle.",
    description_fr: "L'utilisateur se réveille dans un jungle luxuriante, il va explorer cette jungle."
  },
  {
    name_en: 'Sea adventure',
    name_fr: 'Aventure maritime',
    description_en: 'A sea adventure with lots of twists and exploration, accross ocean.',
    description_fr: "Aventure remplie de rebondissement et pleine d'exploration, à traverse les mers."
  },
  {
    name_en: 'In the city',
    name_fr: 'En ville',
    description_en: 'An adventure with lots of twists and exploration, accross the city.',
    description_fr: "Une aventure remplie de rebondissement et pleine d'exploration, à travers la ville."
  },
  {
    name_en: 'Space odyssey',
    name_fr: "Odyssée de l'espace",
    description_en: 'A Space odyssey adventure with lots of twists and exploration, in space.',
    description_fr: "Aventure Odyssée dans l'espace remplie de rebondissement et pleine d'exploration, à traverse l'univers."
  },
  {
    name_en: 'Accross gardens',
    name_fr: 'A travers les jardins',
    description_en: 'A walk accross gardens full of beautiful plants and flowers.',
    description_fr: 'Ballade à travers des jardins pleine de plantes luxuriantes et de fleurs.'
  }
]

company.thematics.insert_all(thematics)

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
  company.characters.create!(character)
end


puts 'Seeding places...'

places = [
  {
    name: "The Great Wall of China",
    description: "Spanning over 13,000 miles, this ancient architectural wonder offers breathtaking views and a glimpse into China's rich history.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "Machu Picchu, Peru",
    description: "Nestled high in the Andes mountains, this mystical Incan city is renowned for its stunning ruins and panoramic vistas.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Taj Mahal, India",
    description: "A UNESCO World Heritage Site, this marble mausoleum is an awe-inspiring symbol of love, featuring intricate architecture and enchanting gardens.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Pyramids of Giza, Egypt",
    description: "These iconic structures date back to ancient times and hold many secrets, attracting visitors with their grandeur and mystical allure.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Colosseum, Italy",
    description: "In the heart of Rome, this colossal amphitheater is a symbol of the ancient Roman Empire, offering visitors a glimpse into the world of gladiator battles.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Great Barrier Reef, Australia",
    description: "A natural wonder of the world, this underwater paradise is home to thousands of marine species and mesmerizing coral formations.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Statue of Liberty, United States",
    description: "Standing tall in New York Harbor, this iconic monument serves as a symbol of freedom and democracy, welcoming visitors to the land of opportunity.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Serengeti National Park, Tanzania",
    description: "Known for its vast savannahs and annual wildebeest migration, this renowned wildlife sanctuary offers unforgettable safari experiences.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Angkor Wat, Cambodia",
    description: "A UNESCO World Heritage Site, this magnificent temple complex features stunning architecture and is the largest religious monument in the world.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  },
  {
    name: "The Eiffel Tower, France",
    description: "A timeless symbol of Paris, this monumental iron lattice tower offers stunning views of the city and is an emblem of architectural innovation.",
    photo: {
      io: URI.parse(FFaker::Image.url(size: '300x300')).open,
      filename: 'place_photo.png'
    }
  }
]

places.each do |place|
  company.places.create!(place)
end

puts 'Seeding prompts...'

media_prompts = [
  {
    type: 'MediaPrompt',
    title: 'Prompt média par défaut',
    body: 'Hyper realistic, epic composition, cinematic, landscape vista photography by Carr Clifton & Galen Rowell, Landscape veduta photo by Dustin Lefevre & tdraw, detailed landscape painting by Ivan Shishkin, rendered in Enscape, Miyazaki, Nausicaa Ghibli, 4k detailed post processing, unreal engine',
    negative_body: 'Deformed, blurry, bad anatomy, disfigured, poorly drawn face, mutation, mutated, extra limb, ugly, poorly drawn hands, missing limb, blurry, floating limbs, disconnected limbs, malformed hands, blur, out of focus, long neck, long body, ((((mutated hands and fingers)))), (((out of frame)))'
  },
  {
    type: 'MediaPrompt',
    title: 'Prompt bande dessinée',
    body: 'comic book',
    negative_body: nil
  }
]

narrator_prompts = [
  {
    type: 'NarratorPrompt',
    title: "Stephen King - Horror",
    body: "From his chilling tales of supernatural entities to psychological thrillers, Stephen King's books plunge readers into a world of fear and suspense, keeping them on the edge of their seats."
  },
  {
    type: 'NarratorPrompt',
    title: "J.R.R. Tolkien - High Fantasy",
    body: "J.R.R. Tolkien's masterpieces transport readers to enchanting realms filled with epic quests, mythical creatures, and intricate world-building, captivating the imagination of generations."
  },
  {
    type: 'NarratorPrompt',
    title: "Guillaume Musso - Romantic Mystery",
    body: "Guillaume Musso's books blend romance and mystery, weaving intricate tales of love, loss, and serendipitous encounters, leaving readers captivated by the twists and turns of his narratives."
  },
  {
    type: 'NarratorPrompt',
    title: "Dan Brown - Thriller",
    body: "With heart-pounding suspense and intricate conspiracies, Dan Brown's thrillers take readers on fast-paced adventures, unraveling hidden secrets and unveiling shocking revelations."
  },
  {
    type: 'NarratorPrompt',
    title: "Jane Austen - Regency Romance",
    body: "Jane Austen's novels transport readers to the elegant world of Regency England, where love, social manners, and societal expectations intertwine, delivering timeless tales of romance and wit."
  },
  {
    type: 'NarratorPrompt',
    title: "George Orwell - Dystopian Fiction",
    body: "George Orwell's dystopian works paint bleak visions of a future society ruled by oppression and surveillance, raising questions about power, freedom, and the nature of truth."
  },
  {
    type: 'NarratorPrompt',
    title: "Gillian Flynn - Psychological Thriller",
    body: "Gillian Flynn's gripping psychological thrillers delve into the darker corners of the human mind, exploring twisted relationships, complex characters, and shocking revelations."
  },
  {
    type: 'NarratorPrompt',
    title: "Gabriel Garcia Marquez - Magical Realism",
    body: "Gabriel Garcia Marquez's magical realism transports readers to dreamlike worlds where reality and fantasy blend seamlessly, creating a unique narrative style that enchants and captivates."
  },
  {
    type: 'NarratorPrompt',
    title: "Agatha Christie - Mystery",
    body: "Agatha Christie's intricate mysteries challenge readers to solve crimes alongside her brilliant detectives, leading them through puzzling plots and surprising conclusions."
  },
  {
    type: 'NarratorPrompt',
    title: "Haruki Murakami - Surreal Fiction",
    body: "Haruki Murakami's surreal novels blur the boundaries between reality and imagination, diving into the subconscious and exploring themes of loneliness, identity, and memory."
  }
]

atmosphere_prompts = [
  {
    type: 'AtmospherePrompt',
    title: "Romantic Prose",
    body: "Her words flowed like a gentle river, painting vivid images of love and longing, weaving intricate stories of passion and heartbreak."
  },
  {
    type: 'AtmospherePrompt',
    title: "Magical Realism",
    body: "In a world where reality and enchantment intertwine, her words painted surreal landscapes, blurring the lines between what is real and what is imagined."
  },
  {
    type: 'AtmospherePrompt',
    title: "Gothic Horror",
    body: "From the dark corners of haunted mansions to the eerie whispers of ghosts, her stories delved into the depths of fear, leaving readers chilled to the bone."
  },
  {
    type: 'AtmospherePrompt',
    title: "Existential Prose",
    body: "Through introspective characters and philosophical musings, her writing explored the complexities of human existence and the search for meaning in life."
  },
  {
    type: 'AtmospherePrompt',
    title: "Historical Fiction",
    body: "Transporting readers back in time, her stories breathed life into forgotten eras, immersing them in historical settings filled with vivid characters and riveting narratives."
  },
  {
    type: 'AtmospherePrompt',
    title: 'Satirical Comedy',
    body: "With a sharp wit and biting humor, her words danced on the pages, exposing the follies of society and provoking laughter as she poked fun at the world around us."
  },
  {
    type: 'AtmospherePrompt',
    title: "Sci-Fi Dystopia",
    body: "In future worlds plagued by oppression and technological dominance, her books painted dystopian landscapes, exploring the darker side of humanity and its consequences."
  },
  {
    type: 'AtmospherePrompt',
    title: "Young Adult Fantasy",
    body: "Her words conjured magical realms and courageous heroes, capturing the hearts of young readers as they embarked on epic quests and discovered their inner strength."
  },
  {
    type: 'AtmospherePrompt',
    title: "Crime Thriller",
    body: "Through gripping suspense and cunning plot twists, her writing plunged readers into a world of crime and detectives, keeping them on the edge of their seats until the final revelation."
  },
  {
    type: 'AtmospherePrompt',
    title: "Poetic Prose",
    body: "Her lyrical words danced off the page, evoking emotions with every line, taking readers on a sensory journey through the beauty and complexity of life."
  }
]

company.media_prompts.insert_all(media_prompts)
company.narrator_prompts.insert_all(narrator_prompts)
company.atmosphere_prompts.insert_all(atmosphere_prompts)

[MediaPrompt, NarratorPrompt, AtmospherePrompt].each do |model|
  model.order(:updated_at).each.with_index(1) do |prompt, index|
    prompt.update_column(:position, index)
  end
end
