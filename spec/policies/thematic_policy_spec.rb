require 'rails_helper'

RSpec.describe ThematicPolicy do
  let(:user) { create :user, role }
  let(:record) { create :thematic, company: user.company }

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

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:record) { create :thematic, company: another_company }

    %i[index new create edit update destroy].each do |action|
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
