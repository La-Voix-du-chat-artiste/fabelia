require 'rails_helper'

RSpec.describe Stories::ChapterPolicy do
  let(:user) { create :user, role }

  let(:story) { create :story, company: user.company }
  let(:record) { create :chapter, story: story }

  let(:context) { { user: user, story: story } }

  %i[create? publish? publish_next? publish_all?].each do |action|
    describe_rule action do
      %i[admin super_admin].each do |user_role|
        succeed "when user is #{user_role}" do
          let(:role) { user_role }

          failed 'when story is disabled' do
            let(:story) { create :story, :disabled, company: user.company }
          end

          failed 'when story is ended' do
            let(:story) { create :story, :ended, company: user.company }
          end
        end
      end

      failed 'when user is standard' do
        let(:role) { :standard }
      end
    end
  end

  %i[publish? publish_next?].each do |action|
    describe_rule action do
      let(:role) { :admin }

      failed 'when chapter is already published' do
        let(:record) { create :chapter, :published, story: story }
      end
    end
  end

  context 'when record is from another company' do
    let(:another_company) { create :company }
    let(:story) { create :story, company: another_company }

    %i[publish? publish_next? publish_all?].each do |action|
      describe_rule action do
        %i[admin super_admin].each do |user_role|
          failed "when user is #{user_role}" do
            let(:role) { user_role }

            failed 'when story is disabled' do
              let(:story) { create :story, :disabled, company: another_company }
            end

            failed 'when story is ended' do
              let(:story) { create :story, :ended, company: another_company }
            end
          end
        end

        failed 'when user is standard' do
          let(:role) { :standard }
        end
      end
    end

    %i[publish? publish_next?].each do |action|
      describe_rule action do
        let(:role) { :admin }

        failed 'when chapter is already published' do
          let(:record) { create :chapter, :published, story: story }
        end
      end
    end
  end
end
