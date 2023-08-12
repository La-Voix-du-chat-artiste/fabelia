class ApplicationJob < ActiveJob::Base
  rescue_from StandardError, with: :broadcast_flash_alert

  private

  def broadcast_flash_alert(e, show_backtrace: false)
    message = "[#{e.class.name}] #{e.message} #{e.backtrace if show_backtrace}"

    Rails.logger.tagged(e.class) do
      Rails.logger.error do
        ActiveSupport::LogSubscriber.new.send(:color, message, :red)
      end
    end

    ApplicationRecord.broadcast_flash(:alert, message)
  end

  def broadcast_flash_notice(message)
    ApplicationRecord.broadcast_flash(:notice, message)
  end
end
