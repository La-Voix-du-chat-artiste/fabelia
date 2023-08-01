class ApplicationJob < ActiveJob::Base
  rescue_from StandardError, with: :broadcast_flash_alert

  private

  def broadcast_flash_alert(e)
    Turbo::StreamsChannel.broadcast_prepend_to(
      :flashes,
      target: 'flashes',
      partial: 'flash',
      locals: {
        flash_type: :alert,
        message: e.message
      }
    )
  end
end
