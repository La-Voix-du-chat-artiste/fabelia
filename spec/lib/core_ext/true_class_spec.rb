require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe TrueClass do
  subject { value.to_bool }

  context 'when value is true' do
    let(:value) { true }

    it { is_expected.to be true }
  end
end
