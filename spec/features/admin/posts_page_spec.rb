require "rails_helper"

describe "User visit posts page" do
  context "signed in as admin" do
    before :each do
      admin = create :user, :admin
      login_as admin
    end

    it "able to go to new post link" do
      visit root_path

      click_on("New Post")
      expect(page).to have_link("New Post", new_admin_post_path)
    end

    it "sees admin controls menu" do
      visit root_path

      expect(page).to have_link("All Users", users_path)
      expect(page).to have_css(".dropdown", "Editor Menu")
      expect(page).to have_css(".dropdown", "Writer menu")
    end
  end
end
