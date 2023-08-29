class NostrProfile
  include StoreModel::Model

  DEFAULT_IDENTITY = 'John Doe'.freeze

  attribute :name, :string
  attribute :display_name, :string
  attribute :picture, :string
  attribute :banner, :string
  attribute :about, :string
  attribute :nip05, :string
  attribute :lud16, :string
  attribute :website, :string

  def identity
    display_name || name || DEFAULT_IDENTITY
  end
end
