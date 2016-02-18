require "rails_helper"

describe "User visit post page" do
  it "sees post information" do
    post = create :post

    visit post_path(post)
    expect(page).to have_css("h1", post.title)
    expect(page).to have_content(post.body)
    expect(page).to have_content("#{time_ago_in_words(post.created_at)}")
  end

  context "when user signed in" do
    before :each do
      user = create :user
      login_as user
    end

    it "can edit post" do
      post = create :post

      visit post_path(post)
      expect(page).to have_link("Edit", edit_post_path(post))
    end

    it "can delete post" do
      post = create :post

      visit post_path(post)
      click_link("Delete")
      expect(page).to_not have_link(post.title, post.title)
      expect(page).to_not have_content(post.created_at.strftime("%B, %d, %Y"))
    end

    it "can leave a new comment" do
      post = create :post

      visit post_path(post)

      fill_in "Name", with: "Name"
      fill_in "Body", with: "Comment text"
      click_button "Create Comment"

      expect(page).to have_content("Name")
      expect(page).to have_content("Comment text")
    end

    it "can delete comment" do
      comment = create :comment

      visit post_path(comment.post)

      within(".comment") do
        click_on("Delete")
      end

      expect(page).to_not have_content(comment.name)
      expect(page).to_not have_content(comment.body)
    end
  end

  context "when user not signed in" do
    it "cant edit posts" do
      post = create :post

      visit post_path(post)

      expect(page).to_not have_link("Edit", edit_post_path(post))
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
  expect(page).to have_content(comment.name)
  expect(page).to have_content(comment.body)
  expect(page).to have_content("#{time_ago_in_words(comment.created_at)}")
end
