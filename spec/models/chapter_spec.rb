require 'rails_helper'

RSpec.describe Chapter do
  describe '[validations rules]' do
    subject { build_stubbed :chapter }

    it { is_expected.to define_enum_for(:status).with_values(described_class.statuses.keys) }
  end
end
