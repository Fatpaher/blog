require 'rails_helper'

describe "User visit posts page" do
  it "should incude links to social sites" do
    visit posts_path

    expect(page).to have_link('Facebook', "href=https://www.facebook.com/paul.pavlovsky.3")
    expect(page).to have_link('Instagram', "href=https://www.instagram.com/fatpaher/")
    expect(page).to have_link('Twitter', "href=https://twitter.com/FatPaher")
    expect(page).to have_link('Email', "href=mailto:fatpaher@gmail.com")
  end


  it "should include all posts" do
    posts = create_list :post, 3

    visit posts_path

    posts.each do |post|
      post_content(post)
    end
  end

  it "should be able to go to new post link" do
    visit posts_path
    expect(page).to have_link('New Post', new_post_path)
  end
end

def post_content(post)
  expect(page).to have_link(post.title, post.title)
  expect(page).to have_content(post.created_at.strftime("%B, %d, %Y"))
end
