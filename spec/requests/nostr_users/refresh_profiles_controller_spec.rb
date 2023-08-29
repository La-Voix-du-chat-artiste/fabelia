require 'rails_helper'

RSpec.describe NostrUsers::RefreshProfilesController do
  describe 'POST /nostr_users/::id/refresh_profiles' do
    subject(:action) { post "/nostr_users/#{nostr_user.id}/refresh_profiles" }

    let!(:nostr_user) { create :nostr_user }

    before do
      allow(NostrServices::FetchProfile).to receive(:call) { {} }
    end

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      describe '[nostr service]' do
        before { action }

        it { expect(NostrServices::FetchProfile).to have_received(:call).with(nostr_user) }
      end

      include_examples 'a redirect response with success message' do
        let(:message) { 'Les métadonnées du profil ont bien été rafraîchies' }
        let(:url_to_redirect) { nostr_users_path }
      end
    end
  end
end