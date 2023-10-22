require 'rails_helper'

RSpec.describe StoryOption do
  subject(:story_option) { described_class.to_type.cast_value(json_data) }

  let(:json_data) do
    {
      chatgpt_full_story_system_prompt: chatgpt_full_story_system_prompt,
      chatgpt_dropper_story_system_prompt: chatgpt_dropper_story_system_prompt,
      stable_diffusion_prompt: stable_diffusion_prompt,
      foo: 'bar'
    }
  end

  let(:chatgpt_full_story_system_prompt) { 'Foo bar' }
  let(:chatgpt_dropper_story_system_prompt) { 'Bar foo' }
  let(:stable_diffusion_prompt) { 'my, keywords, prompt' }

  it { expect(story_option.unknown_attributes).to include('foo' => 'bar') }

  describe '#stable_diffusion_prompt' do
    subject { story_option }

    context 'when value is present' do
      let(:stable_diffusion_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:stable_diffusion_prompt) { '' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: '') }
    end

    context 'when value is nil' do
      let(:stable_diffusion_prompt) { nil }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(stable_diffusion_prompt: nil) }
    end
  end

  describe '#chatgpt_full_story_system_prompt' do
    subject { story_option }

    context 'when value is present' do
      let(:chatgpt_full_story_system_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:chatgpt_full_story_system_prompt) { '' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: '') }
    end

    context 'when value is nil' do
      let(:chatgpt_full_story_system_prompt) { nil }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_full_story_system_prompt: nil) }
    end
  end

  describe '#chatgpt_dropper_story_system_prompt' do
    subject { story_option }

    context 'when value is present' do
      let(:chatgpt_dropper_story_system_prompt) { 'foo bar baz' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: 'foo bar baz') }
    end

    context 'when value is blank' do
      let(:chatgpt_dropper_story_system_prompt) { '' }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: '') }
    end

    context 'when value is nil' do
      let(:chatgpt_dropper_story_system_prompt) { nil }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(chatgpt_dropper_story_system_prompt: nil) }
    end
  end
end
