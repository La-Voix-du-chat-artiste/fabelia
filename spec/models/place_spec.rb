require 'rails_helper'

RSpec.describe Place do
  subject { build :place, company: shared_company }

  include_context 'shared company'

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
end
