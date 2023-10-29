require 'rails_helper'

RSpec.describe CharacterPolicy do
  let(:user) { create :user, role }

  let(:record) { create :character, company: user.company }
  let(:context) { { user: user } }

  describe_rule :update? do
    %i[admin super_admin].each do |user_role|
      succeed "when user is #{user_role}" do
        let(:role) { user_role }
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:record) { create :place, company: another_company }

    describe_rule :update? do
      %i[admin super_admin].each do |user_role|
        failed "when user is #{user_role}" do
          let(:role) { user_role }
        end
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end
end
