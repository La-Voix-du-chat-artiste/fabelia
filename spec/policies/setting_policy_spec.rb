require 'rails_helper'

RSpec.describe SettingPolicy do
  let(:user) { build_stubbed :user, role }
  let(:record) { build_stubbed :setting }

  let(:context) { { user: user } }

  %i[edit update].each do |action|
    describe_rule "#{action}?" do
      succeed 'when user is super admin' do
        let(:role) { :super_admin }
      end

      failed 'when user is admin' do
        let(:role) { :admin }
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end
end
