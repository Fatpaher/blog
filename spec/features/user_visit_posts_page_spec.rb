require 'rails_helper'

describe "User visit posts page" do
  it "should include all posts" do
    posts = create_list :post, 3

    visit posts_path

    posts.each do |post|
      post_content(post)
    end
  end

  context "when user signed in" do
    it "can visit new post link" do
      user = create :user
      login_as user

      visit posts_path
      click_button('New Post')

      expect(page).to have_content('New Post')
    end
  end

  context "when user not signed in" do
    it "can't visit new post link" do
      visit posts_path

      expect(page).to_not have_content('New Post')
    end
  end

  it "sees All posts header" do
    visit root_path
    expect(page).to have_content('All posts')
  end
end

def post_content(post)
  expect(page).to have_link(post.title, post.title)
  expect(page).to have_content(post.created_at.strftime("%B, %d, %Y"))
end
