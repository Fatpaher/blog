require "rails_helper"

describe "User visit user page" do
  describe "sign in as admin" do
    before :each do
      @admin = create :user, :admin
      login_as @admin
    end

    context "visit his own profile page" do
      it "can't delete his own profile" do
        visit user_path @admin

        expect(page).to_not have_link("Delete Profile")
      end
    end

    context "visit other admin page" do
      it "can't delete other admin profile" do
        other_admin = create :user, :admin

        visit user_path other_admin

        expect(page).to_not have_link("Delete Profile")
      end
    end

    context "visit other_user profile" do
      it "can delete user profile" do
        user = create :user

        visit user_path(user)

        expect(page).to have_link("Delete Profile")
      end
    end
  end

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
