class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :require_login

  private

  def not_authenticated
    redirect_to new_sessions_path,
                alert: 'Vous devez être authentifié pour accéder à cette page'
  end
end
