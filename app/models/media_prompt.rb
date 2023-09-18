class MediaPrompt < Prompt
  has_many :stories, dependent: :nullify

  attribute :options, MediaPromptOption.to_type
end

# == Schema Information
#
# Table name: prompts
#
#  id            :bigint(8)        not null, primary key
#  type          :string
#  title         :string
#  body          :text
#  negative_body :text
#  options       :jsonb            not null
#  stories_count :integer          default(0), not null
#  enabled       :boolean          default(TRUE), not null
#  position      :integer          default(1), not null
#  archived_at   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
