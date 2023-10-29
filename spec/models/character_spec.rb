require 'rails_helper'

RSpec.describe Character do
  subject { build :character }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_uniqueness_of(:last_name).scoped_to(:first_name) }
  it { is_expected.to validate_presence_of(:biography) }
end
