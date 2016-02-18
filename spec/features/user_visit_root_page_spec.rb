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

  it "sees All posts title" do
    visit root_path
    expect(page).to have_content("All posts")
  end

  context "when user signed in" do
    it "able to go to new post link" do
      user = create :user
      login_as user

      visit root_path

      click_button("New Post")
      expect(page).to have_link("New Post", new_post_path)
    end

    it "sees log out button" do
      user = create :user
      login_as user

      visit root_path

      expect(page).to have_content("Log Out")
    end
  end

  context "when user not log in" do
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
