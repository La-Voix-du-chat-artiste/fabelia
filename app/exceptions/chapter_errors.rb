class ChapterErrors < BaseErrors
  EmptyPollOptions = Class.new(self)
  MissingPollOptions = Class.new(self)
end
