require 'rails_helper'

RSpec.describe SettingPolicy do
  let(:user) { build_stubbed :user }
  let(:record) { build_stubbed :setting }

  let(:context) { { user: user } }

  describe_rule :show? do
    succeed 'allowed to show action'
  end

  describe_rule :edit? do
    succeed 'allowed to edit action'
  end

  describe_rule :update? do
    succeed 'allowed to update action'
  end
end
