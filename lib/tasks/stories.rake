namespace :stories do
  desc 'Publish next chapter from current complete story'
  task publish_next_chapter: :environment do
    set_logger

    NostrUser.distinct.pluck(:language).each do |language|
      @story = Story.complete.currents.enabled.where(language: language).first

      if @story.blank?
        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Génération et publication d'une nouvelle aventure !", :green)
          end
        end

        GenerateFullStoryJob.perform_now(language, publish: true)
      else
        @chapter = @story.chapters.not_published.first

        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Publication du chapitre ##{@chapter.position} de l'aventure #{@story.title}", :green)
          end
        end

        NostrPublisherService.call(@chapter)
        @chapter.broadcast_chapter
      end
    rescue StandardError => e
      puts e.message
    end
  end
end

private

def set_logger(file: $stdout, level: Logger::INFO)
  logger           = ActiveSupport::TaggedLogging.new(Logger.new(file))
  logger.level     = level
  logger.formatter = Rails.logger.formatter
  Rails.logger     = logger
end
