require 'rails_helper'

RSpec.describe Story do
  describe '[validations rules]' do
    subject { build_stubbed :story }

    it { is_expected.to belong_to(:thematic) }
    it { is_expected.to validate_presence_of(:mode) }
    it { is_expected.to define_enum_for(:mode).with_values(described_class.modes.keys) }
  end
end
