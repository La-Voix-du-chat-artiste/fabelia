class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :require_login

  rescue_from ActionPolicy::Unauthorized, with: :unauthorized_access
  rescue_from StoryErrors, with: :redirect_to_root

  add_flash_types :warning, :info

  helper_method :company, :options

  private

  def company
    Current.company ||= current_user.company
  end

  def not_authenticated
    redirect_to new_sessions_path,
                alert: 'Vous devez être authentifié pour accéder à cette page'
  end

  def unauthorized_access(e)
    policy_name = e.policy.class.to_s.underscore
    message = t "#{policy_name}.#{e.rule}", scope: 'action_policy', default: :default

    redirect_back_or_to root_path, alert: message
  end

  def redirect_to_root(e)
    redirect_to root_path, alert: e.message
  end

  def options
    @options ||= company.setting.chapter_options
  end
end
