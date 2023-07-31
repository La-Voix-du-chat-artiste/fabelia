namespace :stories do
  # @example $ bin/rails stories:publish_next_chapter
  desc 'Publish next chapter from current complete story'
  task publish_next_chapter: :environment do
    set_logger

    NostrUser.distinct.pluck(:language).each do |language|
      @story = Story.publishable(language: language).first

      if @story.blank?
        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Génération et publication d'une nouvelle aventure !", :green)
          end
        end

        GenerateFullStoryJob.perform_now(language, publish: true)
      else
        raise StoryErrors::MissingCover unless @story.cover.attached?

        @chapter = @story.chapters.not_published.first

        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Publication du chapitre [##{@chapter.position}] de l'aventure \"#{@story.title}\"", :green)
          end
        end

        NostrPublisherService.call(@chapter)
        @chapter.broadcast_chapter
        @story.broadcast_next_quick_look_story
      end
    rescue StandardError => e
      Rails.logger.tagged(e.class) do
        Rails.logger.error do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end
    end
  end

  # @example $ bin/rails stories:publish_all_chapters
  desc 'Publish all remaining chapters from current complete story'
  task publish_all_chapters: :environment do
    set_logger

    NostrUser.distinct.pluck(:language).each do |language|
      @story = Story.publishable(language: language).first

      next if @story.nil?
      raise StoryErrors::MissingCover unless @story.cover.attached?

      @story.chapters.not_published.each do |chapter|
        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Publication du chapitre [##{chapter.position}] de l'aventure \"#{@story.title}\"", :green)
          end
        end

        NostrPublisherService.call(chapter)
        chapter.broadcast_chapter
      end

      @story.broadcast_next_quick_look_story
    rescue StandardError => e
      Rails.logger.tagged(e.class) do
        Rails.logger.error do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end
    end
  end

  # @example $ bin/rails stories:generate_and_publish_full_story[french|english]
  desc 'Generate and publish a full story in once'
  task :generate_and_publish_full_story, [:language] => :environment do |_, args|
    set_logger

    language = Story.languages.include?(args[:language]) ? args[:language] : :french

    Rails.logger.tagged(language) do
      Rails.logger.info do
        ActiveSupport::LogSubscriber.new.send(:color, "Génération et publication intégrale d'une nouvelle aventure !", :green)
      end
    end

    GenerateFullStoryJob.perform_now(language, publish: :all)
  end
end

private

def set_logger(file: $stdout, level: Logger::INFO)
  logger           = ActiveSupport::TaggedLogging.new(Logger.new(file))
  logger.level     = level
  logger.formatter = Rails.logger.formatter
  Rails.logger     = logger
end
