require 'rails_helper'

describe "User visit new post page" do
  it "should be able to write new post" do
    visit new_post_path
    fill_in 'Title', with: 'Post title'
    fill_in 'Body', with: 'Post body'
    click_button 'Save Post'

    expect(page).to have_content('Post title')
    expect(page).to have_content('Post body')
  end
  it "can't create post with empty title" do
    visit new_post_path
    fill_in 'Title', with: ''
    click_button 'Save Post'
    expect(page).to_not have_css('title', '')
    expect(page).to have_css('h2', 'prevented this post from saving')
  end
end
