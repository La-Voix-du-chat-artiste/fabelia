require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe NilClass do
  subject { value.to_bool }

  context 'when value is nil' do
    let(:value) { nil }

    it { is_expected.to be false }
  end
end
