require 'rails_helper'

RSpec.describe NostrUser do
  it { is_expected.to validate_presence_of(:private_key) }
  it { is_expected.to validate_presence_of(:relays) }
  it { is_expected.to validate_presence_of(:language) }
  it { is_expected.to validate_uniqueness_of(:language).case_insensitive }

  describe '#metadata_response' do
    subject(:metadata_response) { nostr_user.metadata_response }

    let(:nostr_user) do
      build :nostr_user, private_key: Faker::Crypto.sha256
    end

    describe 'when an error is raised' do
      before do
        allow(NostrServices::FetchProfile).to receive(:call).and_raise(StandardError)
        nostr_user.save!
      end

      it { is_expected.to be_empty }
    end

    describe 'when no error is raised' do
      before do
        allow(NostrServices::FetchProfile).to receive(:call) { { foo: 'bar' } }
        nostr_user.save!
      end

      it { expect(NostrServices::FetchProfile).to have_received(:call).with(nostr_user) }
      it { is_expected.to_not be_empty }
    end
  end

  describe '#profile' do
    subject { nostr_user.profile }

    let(:nostr_user) { build :nostr_user }

    it { is_expected.to be_instance_of(NostrProfile) }
  end

  describe '#human_language' do
    subject { nostr_user.human_language }

    let(:nostr_user) { build :nostr_user, language: language }

    context 'when language is FR' do
      let(:language) { 'FR' }

      it { is_expected.to eq 'Français' }
    end

    context 'when language is EN' do
      let(:language) { 'EN' }

      it { is_expected.to eq 'Anglais' }
    end

    context 'when language is not handled' do
      let(:language) { 'XX' }

      it { is_expected.to eq 'Unknown language' }
    end
  end
end
