# This concern provide sugar to deal with archivable models.
module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archived, -> { where.not(archived_at: nil) }
    scope :available, -> { where(archived_at: nil) }
  end

  def archive!
    update_attribute(:archived_at, Time.current)
  end

  def unarchive!
    update_attribute(:archived_at, nil)
  end

  def available?
    archived_at.nil?
  end

  def archived?
    !available?
  end
end
