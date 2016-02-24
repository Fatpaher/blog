require "rails_helper"

describe Post do
  describe "validations" do
    it {is_expected.to validate_presence_of(:title)}
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should belong_to(:user) }
  end
end
