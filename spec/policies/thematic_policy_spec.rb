require 'rails_helper'

RSpec.describe ThematicPolicy do
  let(:user) { build_stubbed :user, role }
  let(:record) { build_stubbed :thematic }

  let(:context) { { user: user } }

  %i[index new create edit update destroy].each do |action|
    describe_rule "#{action}?" do
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
end
