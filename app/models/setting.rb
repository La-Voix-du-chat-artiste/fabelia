class Setting < ApplicationRecord
  attribute :chapter_options, Option.to_type

  validates :chapter_options, store_model: { merge_errors: true }

  before_create :confirm_singularity

  private

  def confirm_singularity
    raise StandardError.new('There can be only one.') if Setting.exists?
  end
end

# == Schema Information
#
# Table name: settings
#
#  id              :bigint(8)        not null, primary key
#  chapter_options :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
