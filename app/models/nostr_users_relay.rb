class NostrUsersRelay < ApplicationRecord
  belongs_to :nostr_user
  belongs_to :relay
end

# == Schema Information
#
# Table name: nostr_users_relays
#
#  nostr_user_id :bigint(8)        not null
#  relay_id      :bigint(8)        not null
#
# Indexes
#
#  index_nostr_users_relays_on_nostr_user_id_and_relay_id  (nostr_user_id,relay_id) UNIQUE
#
