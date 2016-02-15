require 'rails_helper'

describe "User visit post page" do
  it "should include post information" do
    post = create :post

    visit post_path(post)
    expect(page).to have_css('h1', post.title)
    expect(page).to have_content(post.body)
  end
end
