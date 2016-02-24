require "rails_helper"

describe User do
  describe "associations" do
    it { should have_many(:comments).with_foreign_key(:user_id) }
    it { should have_many(:posts) }
  end
end
