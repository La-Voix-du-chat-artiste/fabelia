require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe Array do
  subject { value.to_bool }

  context 'when value is []' do
    let(:value) { [] }

    it { is_expected.to be false }
  end

  context 'when value is %w[foo bar]' do
    let(:value) { %w[foo bar] }

    it { is_expected.to be true }
  end
end
