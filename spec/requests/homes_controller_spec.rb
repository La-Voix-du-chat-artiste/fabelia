require 'rails_helper'

RSpec.describe HomesController do
  describe 'GET /' do
    subject(:action) { get '/' }

    context 'when not logged in' do
      before { action }

      it { expect(response).to have_http_status :found }
      it { expect(response).to redirect_to new_sessions_path }
      it { expect(flash[:alert]).to match('Vous devez être authentifié pour accéder à cette page') }
    end

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end
end
