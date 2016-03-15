require "rails_helper"

describe "User visit post page" do
  it "sees post information" do
    post = create :post

    visit post_path(post)
    expect(page).to have_css("h1", post.title)
    expect(page).to have_content(post.body)
    expect(page).to have_content("#{time_ago_in_words(post.created_at)}")
    expect(page).to have_content(post.user.email)
  end

  context "when user signed in as admin" do
    before :each do
      @admin = create :user, :admin
      login_as @admin
    end
    it "can delete all posts" do
      post = create :post

      visit post_path(post)

      expect(page).to have_button("Delete")
    end

    it "can edit all posts" do
      post = create :post

      visit post_path(post)

      expect(page).to have_button("Edit")
    end
  end

  context "when user signed in as user" do
    before :each do
      @user = create :user
      login_as @user
    end

    it "can edit own post" do
      post = create :post, user: @user

      visit post_path(post)
      expect(page).to have_link("Edit", edit_admin_post_path(post))
    end

    it "can't edit another user posts" do
      another_user_post = create :post, user: create(:user)

      visit post_path(another_user_post)

      expect(page).to_not have_content("Edit")
    end

    it "can delete own post" do
      post = create :post, user: @user

      visit post_path(post)
      click_link("Delete")
      expect(page).to_not have_link(post.title, post.title)
      expect(page).to_not have_content(post.created_at.strftime("%B, %d, %Y"))
    end
  end

  context "when user not signed in" do
    it "cant edit posts" do
      post = create :post

      visit post_path(post)

      expect(page).to_not have_link("Edit", edit_admin_post_path(post))
    end

    it "can't delete posts" do
      post = create :post

      visit post_path(post)

      expect(page).to_not have_content("Delete")
    end
  end

  it "sees comments to the post" do
    post = create :post
    comments = create_list :comment, 3, post_id:post.id

    visit post_path(post)
      comments.each do |comment|
      comment_content(comment)
    end
  end
end

def comment_content(comment)
  expect(page).to have_content(comment.body)
  expect(page).to have_content("#{time_ago_in_words(comment.created_at)}")
end
