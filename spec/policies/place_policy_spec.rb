require 'rails_helper'

RSpec.describe PlacePolicy do
  let(:user) { build_stubbed :user, role }

  let(:record) { create :place }
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
end
