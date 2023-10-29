require 'rails_helper'

RSpec.describe HomesController do
  include_context 'shared company'

  describe 'GET /' do
    subject(:action) { get '/' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'success request when logged in as standard'
    it_behaves_like 'success request when logged in as admin'
  end
end
