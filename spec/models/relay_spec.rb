require 'rails_helper'

RSpec.describe Relay do
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_uniqueness_of(:url).case_insensitive }

  describe '#title' do
    subject { relay.title }

    let(:relay) { build :relay, url: 'wss://relay.test' }

    it { is_expected.to eq 'wss://relay.test' }
  end

  describe '#url' do
    subject { relay.url }

    let(:relay) { build :relay, url: url }

    before { relay.valid? }

    context 'when url has spaces before and after' do
      let(:url) { '  wss://relay.test    ' }

      it { is_expected.to eq 'wss://relay.test' }
    end

    context 'when url starts with ws://' do
      let(:url) { 'ws://relay.test' }

      it { is_expected.to eq 'ws://relay.test' }
    end

    context 'when url starts with wss://' do
      let(:url) { 'wss://relay.test' }

      it { is_expected.to eq 'wss://relay.test' }
    end

    context 'when url starts with http://' do
      let(:url) { 'http://relay.test' }

      it { is_expected.to eq 'wss://relay.test' }
    end

    context 'when url starts with https://' do
      let(:url) { 'https://relay.test' }

      it { is_expected.to eq 'wss://relay.test' }
    end

    context 'when url does not specify protocol' do
      let(:url) { 'relay.test' }

      it { is_expected.to eq 'wss://relay.test' }
    end
  end
end
