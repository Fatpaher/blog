require 'rails_helper'

describe "User visit post page" do
  it "should include post information" do
    post = create :post

    visit post_path(post)
    expect(page).to have_css('h1', post.title)
    expect(page).to have_content(post.body)
  end
  it "can edit his post" do
    post = create :post

    visit post_path(post)
    expect(page).to have_link('Edit', edit_post_path(post))
  end

  it "can delete his post" do
    post = create :post

    visit post_path(post)
    click_link('Delete')
    save_and_open_page
    expect(page).to_not have_link(post.title, post.title)
    expect(page).to_not have_content(post.created_at.strftime("%B, %d, %Y"))
  end
end
