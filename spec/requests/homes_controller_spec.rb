require 'rails_helper'

RSpec.describe HomesController do
  describe 'GET /' do
    subject(:action) { get '/' }

    it_behaves_like 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end
end
