require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe Numeric do
  subject { value.to_bool }

  context 'when value is 0' do
    let(:value) { 0 }

    it { is_expected.to be false }
  end

  context 'when value is 0.0' do
    let(:value) { 0.0 }

    it { is_expected.to be false }
  end

  context 'when value is 1' do
    let(:value) { 1 }

    it { is_expected.to be true }
  end

  context 'when value is 1.0' do
    let(:value) { 1.0 }

    it { is_expected.to be true }
  end

  context 'when value is 1.5' do
    let(:value) { 1.5 }

    it { is_expected.to be true }
  end
end
