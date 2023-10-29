FactoryBot.define do
  factory :nostr_user do
    display_name { FFaker::Name.name }
    language { I18nData.languages.keys.sample }
    private_key { FFaker::Crypto.sha256 }

    company

    before :create do |nostr_user|
      nostr_user.relays << create_list(:relay, 3, company: nostr_user.company)
    end
  end
end
