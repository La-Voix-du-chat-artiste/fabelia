namespace :stories do
  desc 'Publish next chapter from current complete story'
  task publish_next_chapter: :environment do
    NostrUser.distinct.pluck(:language).each do |language|
      @story = Story.complete.currents.where(language: language).first

      if @story.blank?
        GenerateFullStoryJob.perform_now(language, publish: true)
      else
        @chapter = @story.chapters.not_published.first

        NostrPublisherService.call(@chapter)
      end
    end
  end
end
