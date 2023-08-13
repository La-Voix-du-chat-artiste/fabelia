require 'rails_helper'

RSpec.describe Thematic do
  it { is_expected.to validate_presence_of(:name_fr) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:description_fr) }
  it { is_expected.to validate_presence_of(:description_en) }
  it { is_expected.to validate_presence_of(:identifier) }
  it { is_expected.to validate_uniqueness_of(:identifier).case_insensitive }
end
