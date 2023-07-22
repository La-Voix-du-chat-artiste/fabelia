class ApplicationService
  include Mixin::Callable

  private

  def debug_logger(tag, content, color = :green)
    Rails.logger.tagged(tag) do
      Rails.logger.debug do
        ActiveSupport::LogSubscriber.new.send(:color, content, color)
      end
    end
  end
end
