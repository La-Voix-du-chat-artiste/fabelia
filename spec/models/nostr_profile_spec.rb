require 'rails_helper'

RSpec.describe NostrProfile do
  subject(:nostr_profile) { described_class.new.from_json(json_data.to_json) }

  let(:json_data) { default_json_data }
  let(:default_json_data) do
    {
      display_name: 'Jane Doe',
      name: 'jane doe 123',
      picture: 'http://example.test/picture.jpg',
      banner: 'http://example.test/banner.jpg',
      about: 'Lorem ipsum',
      unhandled_key: 'foobar'
    }
  end

  describe '#identity' do
    subject { nostr_profile.identity }

    context 'when display_name is set' do
      it { is_expected.to eq 'Jane Doe' }
    end

    context 'when display_name is not set' do
      let(:json_data) { default_json_data.except!(:display_name) }

      it { is_expected.to eq 'jane doe 123' }
    end

    context 'when no name key is set' do
      let(:json_data) { default_json_data.except!(:display_name, :name) }

      it { is_expected.to eq 'John Doe' }
    end
  end

  describe '#picture' do
    subject { nostr_profile.picture }

    context 'when picture is not set' do
      let(:json_data) { {} }

      it { is_expected.to be_nil }
    end

    context 'when picture is set' do
      it { is_expected.to eq 'http://example.test/picture.jpg' }
    end
  end

  describe '#banner' do
    subject { nostr_profile.banner }

    context 'when banner is not set' do
      let(:json_data) { {} }

      it { is_expected.to be_nil }
    end

    context 'when banner is set' do
      it { is_expected.to eq 'http://example.test/banner.jpg' }
    end
  end

  describe '#about' do
    subject { nostr_profile.about }

    context 'when about is not set' do
      let(:json_data) { {} }

      it { is_expected.to be_nil }
    end

    context 'when about is set' do
      it { is_expected.to eq 'Lorem ipsum' }
    end
  end
end
