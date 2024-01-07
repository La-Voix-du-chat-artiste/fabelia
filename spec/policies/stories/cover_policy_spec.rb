require 'rails_helper'

RSpec.describe Stories::CoverPolicy do
  let(:user) { create :user, role }

  let(:record) { create :story, company: user.company }
  let(:context) { { user: user } }

  describe_rule :update? do
    %i[admin super_admin].each do |user_role|
      succeed "when user is #{user_role}" do
        let(:role) { user_role }

        failed 'when story is already published' do
          let(:record) { create :story, :published, company: user.company }
        end

        failed 'when story is disabled' do
          let(:record) { create :story, :disabled, company: user.company }
        end

        failed 'when story is ended' do
          let(:record) { create :story, :ended, company: user.company }
        end
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:record) { create :story, company: another_company }

    describe_rule :update? do
      %i[admin super_admin].each do |user_role|
        failed "when user is #{user_role}" do
          let(:role) { user_role }

          failed 'when story is already published' do
            let(:record) { create :story, :published, company: another_company }
          end

          failed 'when story is disabled' do
            let(:record) { create :story, :disabled, company: another_company }
          end

          failed 'when story is ended' do
            let(:record) { create :story, :ended, company: another_company }
          end
        end
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end
end
