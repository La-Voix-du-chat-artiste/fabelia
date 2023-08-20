require 'rails_helper'

RSpec.describe Stories::CoverPolicy do
  let(:user) { build_stubbed :user, role }

  let(:record) { create :story }
  let(:context) { { user: user } }

  describe_rule :update? do
    %i[admin super_admin].each do |user_role|
      succeed "when user is #{user_role}" do
        let(:role) { user_role }

        failed 'when story is already published' do
          let(:record) { create :story, :published }
        end

        failed 'when story is disabled' do
          let(:record) { create :story, :disabled }
        end

        failed 'when story is ended' do
          let(:record) { create :story, :ended }
        end
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end
end
