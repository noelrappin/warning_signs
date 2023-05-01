# frozen_string_literal: true

RSpec.describe WarningSigns do
  it "Can read RailsWarning sample constant value" do
    expect(WarningSigns::SAMPLE_CONSTANT).not_to be_nil
  end
end
