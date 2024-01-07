require 'rails_helper'

RSpec.describe Thematic do
  subject { build :thematic }

  it { is_expected.to validate_presence_of(:name_fr) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:description_fr) }
  it { is_expected.to validate_presence_of(:description_en) }
end
