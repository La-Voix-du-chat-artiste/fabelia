class SettingsController < ApplicationController
  before_action :set_setting, only: %i[edit update]

  # @route GET /settings/edit (edit_settings)
  def edit
    authorize! @setting
  end

  # @route PATCH /settings (settings)
  # @route PUT /settings (settings)
  def update
    authorize! @setting

    respond_to do |format|
      if @setting.update(setting_params)
        format.html do
          notice = 'Les paramètres ont bien été mis à jour'
          path = request.referer.presence || edit_settings_path

          redirect_to path, notice: notice
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_setting
    @setting = company.setting
  end

  def setting_params
    params.require(:setting).permit(chapter_options: {})
  end
end
