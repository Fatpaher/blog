require "rails_helper"

describe User do
  describe "associations" do
    it { should have_many(:comments).with_foreign_key(:user_id) }
    it { should have_many(:posts) }
  end

  describe "role" do
    it { should respond_to(:role) }

    it "should be 'user' by default" do
      user = create :user

      expect(user.role).to eq("user")
    end
  end

  describe "destroy all comments of user when it was delete " do
    it { expect(subject).to have_many(:comments).dependent(:destroy) }
  end
end
