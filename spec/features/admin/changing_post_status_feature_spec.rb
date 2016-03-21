require "rails_helper"

describe "user role eq 'writer'" do
  before :each do
    @writer = create :user, :writer
    login_as @writer
  end

  context "while user in drafts" do
    it "can change messege status from 'drafts' to 'pending'" do
      post = create :post, :draft, user_id: @writer.id

      visit drafts_admin_posts_path

      click_link "Send to review"

      expect(current_path).to eq drafts_admin_posts_path
      expect(page).to_not have_content(post.title)
    end
  end

  context "while user in reviewed" do
    it "can't review his messeges" do
      post = create :post, :pending, user_id: @writer.id

      visit pending_admin_posts_path

      expect(page).to have_content(post.title)
      expect(page).to_not have_link("Mark as reviewed")
    end
  end

  context "while user in reviewed" do
    it "can't publish posts" do
      post = create :post, :reviewed, user_id: @writer.id

      visit reviewed_admin_posts_path

      expect(page).to have_content(post.title)
      expect(page).to_not have_link("Mark as reviewed")
    end
  end
end

describe "user role eq 'editor'" do
  before :each do
    @editor = create :user, :editor
    login_as @editor
  end

  context "while user in 'waiting for review'" do
    it "can change messege status from 'pending' to 'reviewed'" do
      post = create :post, :pending

      visit pending_admin_posts_path
      click_link "Mark as reviewed"

      expect(current_path).to eq pending_admin_posts_path
      expect(page).to_not have_content(post.title)
    end
  end

  context "while user in reviewed" do
    it "can publish all reviewed posts" do
      post = create :post, :reviewed

      visit reviewed_admin_posts_path
      click_link "Publish post"

      expect(current_path).to eq reviewed_admin_posts_path
      expect(page).to_not have_content(post.title)
    end
  end
end
