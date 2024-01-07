require 'rails_helper'

RSpec.describe StoryPolicy do
  let(:user) { create :user, role }
  let(:record) { create :story, company: user.company }

  let(:context) { { user: user } }

  %i[create? destroy?].each do |action|
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

  describe_rule :update? do
    succeed 'when user is super admin' do
      let(:role) { :super_admin }

      failed 'when adventure is ended' do
        before { record.adventure_ended_at = 1.day.ago }
      end
    end

    succeed 'when user is admin' do
      let(:role) { :admin }
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:record) { create :story, company: another_company }

    %i[show? destroy?].each do |action|
      describe_rule action do
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

    describe_rule :update? do
      failed 'when user is super admin' do
        let(:role) { :super_admin }

        failed 'when adventure is ended' do
          before { record.adventure_ended_at = 1.day.ago }
        end
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
