require 'rails_helper'

RSpec.describe Story do
  describe '[validations rules]' do
    subject { build_stubbed :story }

    it { is_expected.to belong_to(:thematic) }
    it { is_expected.to validate_presence_of(:mode) }
    it { is_expected.to define_enum_for(:mode).with_values(described_class.modes.keys) }
    it { is_expected.to define_enum_for(:publication_rule).with_values(described_class.publication_rules.keys) }
  end

  describe '#status' do
    subject { story.status }

    let(:story) { build :story }

    before { story.save }

    it { is_expected.to eq 'draft' }
  end

  describe '#publish_me?' do
    subject { story.publish_me?(index) }

    let(:story) { create :story, mode, publication_rule }
    let(:index) { 0 }

    context 'when story is dropper' do
      let(:mode) { :dropper }

      context 'when not publishing' do
        let(:publication_rule) { :do_not_publish }

        it { is_expected.to be false }
      end

      context 'when publish first' do
        let(:publication_rule) { :publish_first_chapter }

        it { is_expected.to be true }
      end

      context 'when publish all' do
        let(:publication_rule) { :publish_all_chapters }

        it { is_expected.to be false }
      end
    end

    context 'when story is complete' do
      let(:mode) { :complete }

      context 'when not publishing' do
        let(:publication_rule) { :do_not_publish }

        it { is_expected.to be false }
      end

      context 'when publish first' do
        let(:publication_rule) { :publish_first_chapter }

        context 'when index is 0' do
          let(:index) { 0 }

          it { is_expected.to be true }
        end

        context 'when index is not 0' do
          let(:index) { 1 }

          it { is_expected.to be false }
        end
      end

      context 'when publish all' do
        let(:publication_rule) { :publish_all_chapters }

        it { is_expected.to be true }
      end
    end
  end
end
