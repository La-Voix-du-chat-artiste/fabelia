class ApplicationJob < ActiveJob::Base
  rescue_from StandardError, with: :broadcast_flash_alert

  private

  def broadcast_flash_alert(e)
    message = <<~MESSAGE
      [#{e.class.name}]
      #{e.message}
    MESSAGE

    Rails.logger.tagged(e.class) do
      Rails.logger.error do
        ActiveSupport::LogSubscriber.new.send(
          :color,
          "#{message} // #{e.backtrace}",
          :red
        )
      end
    end

    ApplicationRecord.broadcast_flash(:alert, message)
  end

  def broadcast_flash_notice(message)
    ApplicationRecord.broadcast_flash(:notice, message)
  end
end
