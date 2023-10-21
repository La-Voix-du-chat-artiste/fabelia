class Option
  include StoreModel::Model

  MINIMUM_CHAPTERS_COUNT = 4
  MAXIMUM_CHAPTERS_COUNT = 10
  MINIMUM_POLL_SATS = 42
  MAXIMUM_POLL_SATS = 420
  PUBLISH_PREVIOUS = true
  THEMES = %w[light dark].freeze

  attribute :minimum_chapters_count, :integer,
            default: MINIMUM_CHAPTERS_COUNT
  attribute :maximum_chapters_count, :integer,
            default: MAXIMUM_CHAPTERS_COUNT
  attribute :minimum_poll_sats, :integer, default: MINIMUM_POLL_SATS
  attribute :maximum_poll_sats, :integer, default: MAXIMUM_POLL_SATS
  attribute :publish_previous, :boolean, default: PUBLISH_PREVIOUS
  attribute :theme, :string, default: -> { THEMES[1] }

  validates :minimum_chapters_count,
            presence: true,
            numericality: {
              greater_than_or_equal_to: MINIMUM_CHAPTERS_COUNT,
              less_than_or_equal_to: :maximum_chapters_count
            }

  validates :maximum_chapters_count,
            presence: true,
            numericality: {
              less_than_or_equal_to: MAXIMUM_CHAPTERS_COUNT,
              greater_than_or_equal_to: :minimum_chapters_count
            }

  validates :minimum_poll_sats,
            presence: true,
            numericality: {
              greater_than_or_equal_to: MINIMUM_POLL_SATS,
              less_than_or_equal_to: :maximum_poll_sats
            }

  validates :maximum_poll_sats,
            presence: true,
            numericality: {
              less_than_or_equal_to: MAXIMUM_POLL_SATS,
              greater_than_or_equal_to: :minimum_poll_sats
            }

  validates :publish_previous, allow_blank: false, inclusion: [true, false]
  validates :theme, presence: true, inclusion: THEMES

  def publish_previous=(value)
    super(value.to_bool)
  end
end
