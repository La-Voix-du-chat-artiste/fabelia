class Setting < ApplicationRecord
  attribute :chapter_options, Option.to_type

  belongs_to :company

  validates :chapter_options, store_model: { merge_errors: true }

  before_create :confirm_singularity

  private

  def confirm_singularity
    raise StandardError.new('There can be only one.') if company.setting&.persisted?
  end
end

# == Schema Information
#
# Table name: settings
#
#  id              :bigint(8)        not null, primary key
#  chapter_options :jsonb            not null
#  company_id      :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_settings_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
