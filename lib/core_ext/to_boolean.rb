require 'active_support/core_ext/enumerable'

class String
  FALSE_VALUES = ['', '0', 'f', 'F', 'no', 'NO', 'false', 'FALSE', 'off', 'OFF'].to_set

  def to_bool
    FALSE_VALUES.exclude?(self)
  end
end

class Numeric
  def to_bool
    !zero?
  end
end

class Array
  def to_bool
    !empty?
  end
end

class Hash
  def to_bool
    !empty?
  end
end

class TrueClass
  def to_bool
    self
  end
end

class FalseClass
  def to_bool
    self
  end
end

class NilClass
  def to_bool
    false
  end
end
