namespace :stories do
  # @example $ bin/rails stories:publish_next_chapter[fr/en]
  desc 'Publish next chapter from current complete story'
  task :publish_next_chapter, [:language] => :environment do |_, args|
    set_logger

    langs = args[:language]&.split('/') || []
    langs = langs.uniq

    bots = if langs.empty?
      NostrUser.all.enabled
    elsif langs.length == 1 # Only one lang
      nostr_user = NostrUser.find_by(language: langs.first)

      if nostr_user.nil?
        e = NostrUserErrors::BotMissing.new(language: langs.first)

        Rails.logger.tagged(e.class) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
          end
        end

        []
      elsif !nostr_user.enabled?
        e = NostrUserErrors::BotDisabled.new(nostr_user)

        Rails.logger.tagged(e.class) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
          end
        end

        []
      else
        [nostr_user]
      end
    else # More than one language
      nostr_users = []

      langs.each do |lang|
        nostr_user = NostrUser.find_by(language: lang)

        if nostr_user.nil?
          e = NostrUserErrors::BotMissing.new(language: lang)

          Rails.logger.tagged(e.class) do
            Rails.logger.info do
              ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
            end
          end

          []
        elsif !nostr_user.enabled?
          e = NostrUserErrors::BotDisabled.new(nostr_user)

          Rails.logger.tagged(e.class) do
            Rails.logger.info do
              ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
            end
          end

          []
        else
          nostr_users << nostr_user
        end
      end

      nostr_users
    end

    bots.compact.each do |bot|
      @story = Story.publishable(language: bot.language).first

      if @story.blank?
        Rails.logger.tagged(bot.language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Génération et publication d'une nouvelle aventure !", :green)
          end
        end

        draft_story = Story.create! do |story|
          story.mode = :complete
          story.status = :draft
          story.publication_rule = :publish_first_chapter
          story.nostr_user = bot
        end

        GenerateFullStoryJob.perform_now(draft_story)
      else
        raise StoryErrors::MissingCover unless @story.cover.attached?

        @chapter = @story.chapters.not_published.first

        Rails.logger.tagged(bot.language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Publication du chapitre [##{@chapter.position}] de l'aventure \"#{@story.title}\"", :green)
          end
        end

        NostrPublisherService.call(@chapter)
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

      @story.chapters.not_published.by_position.each do |chapter|
        Rails.logger.tagged(language) do
          Rails.logger.info do
            ActiveSupport::LogSubscriber.new.send(:color, "Publication du chapitre [##{chapter.position}] de l'aventure \"#{@story.title}\"", :green)
          end
        end

        NostrPublisherService.call(chapter)
      end
    rescue StandardError => e
      Rails.logger.tagged(e.class) do
        Rails.logger.error do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end
    end
  end

  # @example $ bin/rails stories:generate_and_publish_full_story[fr|en]
  desc 'Generate and publish a full story in once'
  task :generate_and_publish_full_story, [:language] => :environment do |_, args|
    set_logger

    lang = args[:language].presence || 'fr'

    nostr_user = NostrUser.find_by(language: lang.upcase)

    if nostr_user.nil?
      e = NostrUserErrors::BotMissing.new(language: lang)

      Rails.logger.tagged(e.class) do
        Rails.logger.info do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end
    elsif !nostr_user.enabled?
      e = NostrUserErrors::BotDisabled.new(nostr_user)

      Rails.logger.tagged(e.class) do
        Rails.logger.info do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end
    else
      Rails.logger.tagged(lang) do
        Rails.logger.info do
          ActiveSupport::LogSubscriber.new.send(:color, "Génération et publication intégrale d'une nouvelle aventure !", :green)
        end
      end

      draft_story = Story.create! do |story|
        story.mode = :complete
        story.status = :draft
        story.publication_rule = :publish_all_chapters
        story.nostr_user = nostr_user
      end

      GenerateFullStoryJob.perform_now(draft_story)
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
