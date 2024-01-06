require 'rails_helper'

RSpec.describe User do
  it { is_expected.to define_enum_for(:role).with_values(described_class.roles.keys) }
end
