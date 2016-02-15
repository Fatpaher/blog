require 'rails_helper'

describe "User visit posts page" do
  it "should include all posts" do
    posts = create_list :post, 3

    visit posts_path

    posts.each do |post|
      post_content(post)
    end
  end
end


def post_content(post)
  expect(page).to have_link(post.title, post.title)
  expect(page).to have_content(post.created_at.strftime("%B, %d, %Y"))
end
