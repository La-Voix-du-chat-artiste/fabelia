class AtmospherePrompt < Prompt
  has_many :stories, dependent: :nullify
end

# == Schema Information
#
# Table name: prompts
#
#  id            :uuid             not null, primary key
#  type          :string
#  title         :string
#  body          :text
#  negative_body :text
#  options       :jsonb            not null
#  stories_count :integer          default(0), not null
#  enabled       :boolean          default(TRUE), not null
#  position      :integer          default(1), not null
#  archived_at   :datetime
#  company_id    :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_prompts_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
