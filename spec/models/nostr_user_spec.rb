require 'rails_helper'

RSpec.describe NostrUser do
  it { is_expected.to validate_presence_of(:private_key) }
  it { is_expected.to validate_presence_of(:relays) }
end
