require 'rails_helper'

RSpec.describe ThematicPolicy do
  let(:user) { build_stubbed :user }
  let(:record) { build_stubbed :thematic }

  let(:context) { { user: user } }

  describe_rule :index? do
    succeed 'allowed to index action'
  end

  describe_rule :new? do
    succeed 'allowed to new action'
  end

  describe_rule :create? do
    succeed 'allowed to create action'
  end

  describe_rule :edit? do
    succeed 'allowed to edit action'
  end

  describe_rule :update? do
    succeed 'allowed to update action'
  end

  describe_rule :destroy? do
    succeed 'allowed to destroy action'
  end
end
