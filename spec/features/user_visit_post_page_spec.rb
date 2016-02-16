require 'rails_helper'

describe "User visit post page" do
  it "sees post information" do
    post = create :post

    visit post_path(post)
    expect(page).to have_css('h1', post.title)
    expect(page).to have_content(post.body)
    expect(page).to have_content("#{time_ago_in_words(post.created_at)}")
  end
  it "can edit his post" do
    post = create :post

    visit post_path(post)
    expect(page).to have_link('Edit', edit_post_path(post))
  end

  it "can delete post" do
    post = create :post

    visit post_path(post)
    click_link('Delete')
    expect(page).to_not have_link(post.title, post.title)
    expect(page).to_not have_content(post.created_at.strftime("%B, %d, %Y"))
  end
  it "sees comments to the post" do
    post = create :post
    comments = create_list :comment, 3, post_id:post.id

    visit post_path(post)
      comments.each do |comment|
      comment_content(comment)
    end
  end
  it "can leave a new comment" do
    post = create :post

    visit post_path(post)

    fill_in 'Name', with: 'Name'
    fill_in 'Body', with: 'Comment text'
    click_button 'Create Comment'

    expect(page).to have_content('Name')
    expect(page).to have_content('Comment text')
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

def comment_content(comment)
  expect(page).to have_content(comment.name)
  expect(page).to have_content(comment.body)
  expect(page).to have_content("#{time_ago_in_words(comment.created_at)}")
end
