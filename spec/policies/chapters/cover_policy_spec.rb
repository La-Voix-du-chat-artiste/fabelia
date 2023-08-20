require 'rails_helper'

RSpec.describe Chapters::CoverPolicy do
  let(:user) { build_stubbed :user, role }

  let(:story) { build_stubbed :story }
  let(:record) { build_stubbed :chapter, story: story }

  let(:context) { { user: user } }

  describe_rule :update? do
    %i[admin super_admin].each do |user_role|
      succeed "when user is #{user_role}" do
        let(:role) { user_role }

        failed 'when chapter is already published' do
          let(:record) { build_stubbed :chapter, :published }
        end

        failed 'when story is disabled' do
          let(:story) { build_stubbed :story, :disabled }
        end
      end
    end

    failed 'when user is standard' do
      let(:role) { :standard }
    end
  end
end
