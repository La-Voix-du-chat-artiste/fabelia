class NostrProfile
  include ActiveModel::Serializers::JSON

  DEFAULT_IDENTITY = 'John Doe'.freeze

  attr_accessor :name, :display_name, :picture, :banner, :about

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    rescue NoMethodError
      next
    end
  end

  def identity
    display_name || name || DEFAULT_IDENTITY
  end
end
