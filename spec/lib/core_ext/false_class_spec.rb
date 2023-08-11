require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe FalseClass do
  subject { value.to_bool }

  context 'when value is false' do
    let(:value) { false }

    it { is_expected.to be false }
  end
end
