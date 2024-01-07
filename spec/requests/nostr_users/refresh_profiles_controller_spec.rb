require 'rails_helper'

RSpec.describe NostrUsers::RefreshProfilesController do
  include_context 'shared company'

  describe 'POST /nostr_users/::id/refresh_profiles' do
    subject(:action) { post "/nostr_users/#{nostr_user.id}/refresh_profiles" }

    let(:nostr_user) { create :nostr_user, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before do
        allow(NostrServices::ImportProfile).to receive(:call) { {} }
      end

      describe '[nostr service]' do
        before { action }

        it { expect(NostrServices::ImportProfile).to have_received(:call).with(nostr_user) }
      end

      include_examples 'a redirect response with success message' do
        let(:message) { 'Les métadonnées du profil ont bien été rafraîchies' }
        let(:url_to_redirect) { nostr_users_path }
      end
    end
  end
end
