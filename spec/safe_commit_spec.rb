# frozen_string_literal: true

RSpec.describe SafeCommit do
  it "has a version number" do
    expect(SafeCommit::VERSION).not_to be_nil
  end
end
