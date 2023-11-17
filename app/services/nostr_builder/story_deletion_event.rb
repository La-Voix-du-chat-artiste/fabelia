module NostrBuilder
  # @see https://github.com/nostr-protocol/nips/blob/master/09.md
  class StoryDeletionEvent < BaseEvent
    attr_reader :story

    def initialize(story)
      @story = story
    end

    def call
      nostr.build_deletion_event(events)
    end

    private

    def events
      [].tap do |events|
        events.push(story.back_cover_nostr_identifier) if story.back_cover_published?

        story.chapters.published.each do |chapter|
          events.push(chapter.nostr_identifier)
        end

        events.push(story.nostr_identifier) if story.front_cover_published?
      end
    end

    def nostr_user
      story.nostr_user
    end
  end
end
