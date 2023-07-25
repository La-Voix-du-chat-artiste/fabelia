namespace :stories do
  desc 'Publish next chapter from current complete story'
  task publish_next_chapter: :environment do
    NostrUser.distinct.pluck(:language).each do |language|
      @story = Story.complete.currents.where(language: language).first

      if @story.blank?
        prompt = I18n.t('begin_adventure', theme: Story::THEMATICS.sample, locale: language.first(2))
        GenerateFullStoryJob.perform_now(prompt, language, publish: true)
      else
        @chapter = @story.chapters.not_published.first

        NostrPublisherService.call(@chapter)
      end
    end
  end
end
