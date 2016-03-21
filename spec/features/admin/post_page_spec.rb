require "rails_helper"

describe "User visit post page" do
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
end
