system('noscl', 'relay', 'add', ENV.fetch('NOSTR_RELAY_URL'))
system('noscl', 'setprivate', ENV.fetch('NOSTR_PRIVATE_KEY'))
