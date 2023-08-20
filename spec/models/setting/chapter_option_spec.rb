require 'rails_helper'

RSpec.describe Setting::ChapterOption do
  subject(:chapter_option) { described_class.to_type.cast_value(json_data) }

  let(:json_data) do
    {
      minimum_chapters_count: minimum_chapters_count,
      maximum_chapters_count: maximum_chapters_count,
      chatgpt_full_story_system_prompt: chatgpt_full_story_system_prompt,
      chatgpt_dropper_story_system_prompt: chatgpt_dropper_story_system_prompt,
      stable_diffusion_prompt: stable_diffusion_prompt,
      minimum_poll_sats: minimum_poll_sats,
      maximum_poll_sats: maximum_poll_sats,
      publish_previous: publish_previous,
      foo: 'bar'
    }
  end

  let(:minimum_chapters_count) { 4 }
  let(:maximum_chapters_count) { 10 }
  let(:chatgpt_full_story_system_prompt) { 'Foo bar' }
  let(:chatgpt_dropper_story_system_prompt) { 'Bar foo' }
  let(:stable_diffusion_prompt) { 'my, keywords, prompt' }
  let(:minimum_poll_sats) { 42 }
  let(:maximum_poll_sats) { 420 }
  let(:publish_previous) { true }

  it { expect(chapter_option.unknown_attributes).to include('foo' => 'bar') }

  describe '#minimum_chapters_count' do
    subject { chapter_option }

    context 'when value is lower than maximum_chapters_count' do
      let(:minimum_chapters_count) { 6 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(minimum_chapters_count: 6) }
    end

    context 'when value is equal to maximum_chapters_count' do
      let(:minimum_chapters_count) { 10 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(minimum_chapters_count: 10) }
    end

    context 'when value is higher than maximum_chapters_count' do
      let(:minimum_chapters_count) { 30 }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(minimum_chapters_count: 30) }
    end
  end

  describe '#maximum_chapters_count' do
    subject { chapter_option }

    context 'when value is lower than minimum_chapters_count' do
      let(:maximum_chapters_count) { 1 }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(maximum_chapters_count: 1) }
    end

    context 'when value is equal to minimum_chapters_count' do
      let(:maximum_chapters_count) { 4 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(maximum_chapters_count: 4) }
    end

    context 'when value is higher than minimum_chapters_count' do
      let(:maximum_chapters_count) { 9 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(maximum_chapters_count: 9) }
    end
  end

  describe '#stable_diffusion_prompt' do
    subject { chapter_option }

    context 'when value is present' do
      let(:stable_diffusion_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:stable_diffusion_prompt) { '' }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: '') }
    end

    context 'when value is nil' do
      let(:stable_diffusion_prompt) { nil }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: nil) }
    end
  end

  describe '#chatgpt_full_story_system_prompt' do
    subject { chapter_option }

    context 'when value is present' do
      let(:chatgpt_full_story_system_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:chatgpt_full_story_system_prompt) { '' }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: '') }
    end

    context 'when value is nil' do
      let(:chatgpt_full_story_system_prompt) { nil }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: nil) }
    end
  end

  describe '#chatgpt_dropper_story_system_prompt' do
    subject { chapter_option }

    context 'when value is present' do
      let(:chatgpt_dropper_story_system_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:chatgpt_dropper_story_system_prompt) { '' }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: '') }
    end

    context 'when value is nil' do
      let(:chatgpt_dropper_story_system_prompt) { nil }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: nil) }
    end
  end

  describe '#minimum_poll_sats' do
    subject { chapter_option }

    context 'when value is lower than maximum_poll_sats' do
      let(:minimum_poll_sats) { 100 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(minimum_poll_sats: 100) }
    end

    context 'when value is equal to maximum_poll_sats' do
      let(:minimum_poll_sats) { 420 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(minimum_poll_sats: 420) }
    end

    context 'when value is higher than maximum_poll_sats' do
      let(:minimum_poll_sats) { 500 }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(minimum_poll_sats: 500) }
    end
  end

  describe '#maximum_poll_sats' do
    subject { chapter_option }

    context 'when value is lower than minimum_poll_sats' do
      let(:maximum_poll_sats) { 20 }

      it { is_expected.to_not be_valid }
      it { is_expected.to have_attributes(maximum_poll_sats: 20) }
    end

    context 'when value is equal to minimum_poll_sats' do
      let(:maximum_poll_sats) { 42 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(maximum_poll_sats: 42) }
    end

    context 'when value is higher than minimum_poll_sats' do
      let(:maximum_poll_sats) { 100 }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(maximum_poll_sats: 100) }
    end
  end

  describe '#publish_previous' do
    subject { chapter_option }

    context 'when value is empty' do
      let(:publish_previous) { nil }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(publish_previous: false) }
    end

    context 'when value is not a boolean' do
      let(:publish_previous) { 'foo' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(publish_previous: true) }
    end

    context 'when value is false boolean' do
      let(:publish_previous) { false }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(publish_previous: false) }
    end

    context 'when value is true boolean' do
      let(:publish_previous) { true }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(publish_previous: true) }
    end
  end
end
