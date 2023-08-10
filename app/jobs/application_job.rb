class ApplicationJob < ActiveJob::Base
  rescue_from StandardError, with: :broadcast_flash_alert

  private

  def broadcast_flash_alert(e)
    ApplicationRecord.broadcast_flash(:alert, e.message)
  end

  def broadcast_flash_notice(message)
    ApplicationRecord.broadcast_flash(:notice, message)
  end
end
