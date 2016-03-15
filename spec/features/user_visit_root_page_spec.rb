require "rails_helper"

describe "User visit posts page" do
  it "should incude links to social sites" do
    visit root_path

    expect(page).to have_link("Facebook",
                              "href=https://www.facebook.com/paul.pavlovsky.3")
    expect(page).to have_link("Instagram",
                              "href=https://www.instagram.com/fatpaher/")
    expect(page).to have_link("Twitter", "href=https://twitter.com/FatPaher")
    expect(page).to have_link("Email", "href=mailto:fatpaher@gmail.com")
  end

  context "signed in as admin" do
    it "able to go to new post link" do
      admin = create :admin
      login_as admin

      visit root_path

      click_on("New Post")
      expect(page).to have_link("New Post", new_post_path)
    end

    it "sees users list button" do
      admin = create :admin
      login_as admin

      visit root_path

      expect(page).to have_link("All Users", users_path)
    end
  end

  context "signed in as user" do
    before :each do
      @user = create :user
      login_as @user
    end

    it "can't see button New Post" do
      visit root_path

      expect(page).to_not have_content("New Post")
    end

    it "sees logout button " do
      visit root_path

      expect(page).to have_content("Log Out")
    end

    it "sees profile link" do
      visit root_path

      expect(page).to have_link("Profile", user_path(@user))
    end
  end

  context "not log in" do
    it "should be able to go to log in page" do
      visit root_path

      click_link "Login"
      expect(page).to have_content("Log in")
    end

    it "should be able to go to sign up page" do
      visit root_path

      click_link "Sign up"
      expect(page).to have_content("Sign up")
    end
  end
end
