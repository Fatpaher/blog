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
