class ApplicationJob < ActiveJob::Base
  rescue_from StandardError, with: :broadcast_flash_alert

  private

  def broadcast_flash_alert(e, show_backtrace: false)
    ApplicationRecord.broadcast_flash(:alert,
      "[#{e.class.name}] #{e.message} #{e.backtrace if show_backtrace}"
    )
  end

  def broadcast_flash_notice(message)
    ApplicationRecord.broadcast_flash(:notice, message)
  end
end
