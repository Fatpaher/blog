require "rails_helper"

describe "User views Pages" do
  describe "About page" do
    it "sees About content" do
      visit about_path
      expect(page).to have_content("Hey! It's about page")
    end
    it "sees About header" do
      visit about_path
      expect(page).to have_content("About")
    end
  end
end
