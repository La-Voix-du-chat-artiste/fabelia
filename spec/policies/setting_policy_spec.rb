require 'rails_helper'

RSpec.describe SettingPolicy do
  let(:user) { create :user, role }
  let(:record) { create :setting, company: user.company }

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

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:record) { create :setting, company: another_company }

    %i[edit update].each do |action|
      describe_rule "#{action}?" do
        failed 'when user is super admin' do
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
end
