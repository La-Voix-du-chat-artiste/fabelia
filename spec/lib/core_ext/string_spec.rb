require 'spec_helper'
require 'core_ext/to_boolean'

RSpec.describe String do
  subject { value.to_bool }

  context "when value is ''" do
    let(:value) { '' }

    it { is_expected.to be false }
  end

  context "when value is '0'" do
    let(:value) { '0' }

    it { is_expected.to be false }
  end

  context "when value is 'f'" do
    let(:value) { 'f' }

    it { is_expected.to be false }
  end

  context "when value is 'F'" do
    let(:value) { 'F' }

    it { is_expected.to be false }
  end

  context "when value is 'no'" do
    let(:value) { 'no' }

    it { is_expected.to be false }
  end

  context "when value is 'NO'" do
    let(:value) { 'NO' }

    it { is_expected.to be false }
  end

  context "when value is 'false'" do
    let(:value) { 'false' }

    it { is_expected.to be false }
  end

  context "when value is 'FALSE'" do
    let(:value) { 'FALSE' }

    it { is_expected.to be false }
  end

  context "when value is 'off'" do
    let(:value) { 'off' }

    it { is_expected.to be false }
  end

  context "when value is 'OFF'" do
    let(:value) { 'OFF' }

    it { is_expected.to be false }
  end

  context "when value is '1'" do
    let(:value) { '1' }

    it { is_expected.to be true }
  end

  context "when value is 't'" do
    let(:value) { 't' }

    it { is_expected.to be true }
  end

  context "when value is 'T'" do
    let(:value) { 'T' }

    it { is_expected.to be true }
  end

  context "when value is 'true'" do
    let(:value) { 'true' }

    it { is_expected.to be true }
  end

  context "when value is 'TRUE'" do
    let(:value) { 'TRUE' }

    it { is_expected.to be true }
  end

  context "when value is 'on'" do
    let(:value) { 'on' }

    it { is_expected.to be true }
  end

  context "when value is 'ON'" do
    let(:value) { 'ON' }

    it { is_expected.to be true }
  end

  context "when value is ' '" do
    let(:value) { ' ' }

    it { is_expected.to be true }
  end

  context "when value is 'SOMETHING RANDOM'" do
    let(:value) { 'SOMETHING RANDOM' }

    it { is_expected.to be true }
  end
end
