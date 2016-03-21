require "rails_helper"

describe "User visit user page" do

  describe "sign in as user" do
    before :each do
      @user = create :user
      login_as @user
    end

    it "sees user information" do
      visit user_path(@user)

      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.role)
    end

    it "can delete his own profile" do
      visit user_path(@user)

      expect(page).to have_link("Delete Profile")
    end
  end
end
