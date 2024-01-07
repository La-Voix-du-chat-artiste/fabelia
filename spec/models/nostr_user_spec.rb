require 'rails_helper'

RSpec.describe NostrUser do
  describe '[validations rules]' do
    subject { build_stubbed :nostr_user }

    it { is_expected.to define_enum_for(:mode).with_values(described_class.modes.keys) }
  end

  describe '#mode' do
    subject(:nostr_user) do
      described_class.new(mode: mode, display_name: 'John Doe', company: company)
    end

    let(:company) { create :company }

    before do
      relay = build_stubbed :relay
      nostr_user.relays = [relay]
    end

    context 'when generated' do
      let(:mode) { :generated }

      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:private_key).allow_nil }
      it { is_expected.to validate_presence_of(:relays) }
      it { is_expected.to validate_presence_of(:language) }
      it { is_expected.to_not validate_uniqueness_of(:language) }
      it { is_expected.to allow_value(nil, '', 'foo@bar.com').for(:nip05) }
      it { is_expected.to_not allow_value('foobar', 'foobar.com').for(:nip05) }
      it { is_expected.to allow_value(nil, '', 'foo@bar.com').for(:lud16) }
      it { is_expected.to_not allow_value('foobar', 'foobar.com').for(:lud16) }
    end

    context 'when imported' do
      let(:mode) { :imported }

      it { is_expected.to_not validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:private_key) }
      it { is_expected.to validate_presence_of(:relays) }
      it { is_expected.to validate_presence_of(:language) }
      it { is_expected.to_not validate_uniqueness_of(:language) }
      it { is_expected.to allow_value(nil, '', 'foo@bar.com').for(:nip05) }
      it { is_expected.to_not allow_value('foobar', 'foobar.com').for(:nip05) }
      it { is_expected.to allow_value(nil, '', 'foo@bar.com').for(:lud16) }
      it { is_expected.to_not allow_value('foobar', 'foobar.com').for(:lud16) }
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

  describe '#initials' do
    subject { nostr_user.initials }

    let(:nostr_user) { build :nostr_user, name: name }

    context 'when account has a firstname, a middlename and a lastname' do
      let(:name) { 'John Moon Doe' }

      it { is_expected.to eq 'JM' }
    end

    context 'when account has a firstname and a lastname' do
      let(:name) { 'John Doe' }

      it { is_expected.to eq 'JD' }
    end

    context 'when account has only a firstname' do
      let(:name) { 'John' }

      it { is_expected.to eq 'J' }
    end

    context 'when account does not have name' do
      let(:name) { nil }

      it { is_expected.to be_nil }
    end
  end
end
