require 'rails_helper'

RSpec.describe Company do
  describe '[validations rules]' do
    subject { build_stubbed :company }

    it { is_expected.to validate_presence_of(:name) }
  end
end
