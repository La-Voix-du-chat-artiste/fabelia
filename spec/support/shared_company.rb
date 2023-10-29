RSpec.shared_context 'shared company' do # rubocop:disable RSpec/ContextWording
  let!(:shared_company) { create :company } # rubocop:disable RSpec/LetSetup
end
