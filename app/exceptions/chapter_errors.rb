class ChapterErrors < BaseErrors
  EmptyPollOptions = Class.new(self)
  MissingPollOptions = Class.new(self)
  FullStoryMissingChapters = Class.new(self)
end
