require 'rails_helper'

RSpec.describe PromptPolicy do
  let(:user) { build_stubbed :user, role }
  let(:record) { build_stubbed :narrator_prompt, stories_count: stories_count }

  let(:context) { { user: user } }
  let(:stories_count) { 0 }

  %i[index? new? create? edit? update? archive?].each do |action|
    describe_rule action do
      succeed 'when user is super admin' do
        let(:role) { :super_admin }
      end

      succeed 'when user is admin' do
        let(:role) { :admin }
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end

  describe_rule :destroy? do
    %i[admin super_admin].each do |user_role|
      describe "when user is #{user_role}" do
        let(:role) { :super_admin }

        succeed 'when prompt is not tied to any story and not last one' do
          before do
            create_list :narrator_prompt, 2 # other prompt of this type
          end
        end

        failed 'when prompt is tied to stories' do
          let(:stories_count) { 1 }
        end
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end
end
