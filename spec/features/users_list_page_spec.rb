require "rails_helper"

describe "User visit users list page" do
  before :each do
    @admin = create :admin
    login_as @admin
  end

  it "sees users list" do
    users = create_list :user, 2

    visit users_path

    users.each do |user|
      user_content(user)
    end
  end
end

def user_content(user)
  expect(page).to have_content(user.email)
  expect(page).to have_content(user.role)
end
