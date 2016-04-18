# require "rails_helper"

describe "User visit users list page sign in as admin" do
  before :each do
    @admin = create :user, :admin
    login_as @admin
  end

  it "sees users list" do
    users = create_list :user, 2

    visit users_path

    users.each do |user|
      expect(page).to have_link(user.email, user_path(user))
      expect(page).to have_content(user.role)
    end
  end

  it "can change user role" do
    create :user

    visit users_path

    within "#edit_user_2" do
      select "writer", from: "user[role]"
      click_button "Change role"
    end

    expect(page).to have_content('writer')
  end

  it "can't change own status" do
    visit users_path

    expect(page).to_not have_content("Change role")
    expect(page).to_not have_content('admin')
  end
end
