require "rails_helper"

describe "User visit posts page" do
  it "sees all posts" do
    posts = create_list :post, 3, :published

    visit posts_path

    posts.each do |post|
      post_content(post)
    end
  end

  it "sees body of post if it shorter than 140 characters" do
    create :post, :published, body: "a" * 139

    visit posts_path

    expect(page).to have_content "a" * 139
  end

  it "sees preview of post body" do
    create :post, :published, body: "a" * 500

    visit posts_path

    expect(page).to have_content("a" * 137 + "...")
  end

  it "sees Read more button" do
    post = create :post, :published

    visit posts_path

    expect(page).to have_link("Read More", post_path(post))
  end

  it "sees Comments count" do
    post = create :post, :published, :with_comments

    visit posts_path

    expect(page).to have_link("#{post.comments.count} Comment", post_path(post))
  end
end

def post_content(post)
  expect(page).to have_link(post.title, post.title)
  expect(page).to have_content(post.created_at.strftime("%B, %d, %Y"))
end
