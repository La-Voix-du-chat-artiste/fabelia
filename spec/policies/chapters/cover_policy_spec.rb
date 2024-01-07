require 'rails_helper'

RSpec.describe Chapters::CoverPolicy do
  let(:user) { create :user, role }

  let(:story) { create :story, company: user.company }
  let(:record) { create :chapter, story: story }

  let(:context) { { user: user } }

  describe_rule :update? do
    %i[admin super_admin].each do |user_role|
      succeed "when user is #{user_role}" do
        let(:role) { user_role }

        failed 'when chapter is already published' do
          let(:record) { create :chapter, :published, story: story }
        end

        failed 'when story is disabled' do
          let(:story) { create :story, :disabled, company: user.company }
        end
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:story) { create :story, company: another_company }

    describe_rule :update? do
      %i[admin super_admin].each do |user_role|
        failed "when user is #{user_role}" do
          let(:role) { user_role }

          failed 'when chapter is already published' do
            let(:record) { create :chapter, :published, story: story }
          end

          failed 'when story is disabled' do
            let(:story) { create :story, :disabled, company: another_company }
          end
        end
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end
end
