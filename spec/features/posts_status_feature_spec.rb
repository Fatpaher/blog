require "rails_helper"

describe "Visit root path" do
  it "sees only published posts" do
    published_post = create :post, :published
    draft_post = create :post, :draft

    visit root_path

    expect(page).to have_content(published_post.title)
    expect(page).to_not have_content(draft_post.title)
  end
end
