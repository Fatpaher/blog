require "rails_helper"

describe "user role eq 'writer'" do
  before :each do
    @writer = create :user, :writer
    login_as @writer
  end

  describe "visit root path" do
    it "sees writer menu" do
      visit root_path
      expect(page).to have_content("Writer menu")
      expect(page).to have_content("Drafts")
      expect(page).to have_content("Waiting for review")
      expect(page).to have_content("Reviewed")
      expect(page).to have_content("Published")
    end

    context "drafts" do
      it "sees page with his own posts in 'draft' status" do
        posts = create_posts(status: :draft)
        draft_post, other_user_draft_post, published_post = posts

        visit root_path
        click_link "Drafts"

        expect_page_to_have(
          title: "Drafts",
          to_have: draft_post,
          not_to_have: [published_post, other_user_draft_post],
        )
      end
    end

    context "waiting for review" do
      it "sees page with his own posts in 'pending' status" do
        posts = create_posts(status: :pending)
        pending_post, other_user_pending_post, published_post = posts

        visit root_path
        click_link "Waiting for review"

        expect_page_to_have(
          title: "Waiting for review",
          to_have: pending_post,
          not_to_have: [published_post, other_user_pending_post],
        )
      end
    end

    context "reviewed" do
      it "sees page with his own posts in 'reviewed' status" do
        posts = create_posts(status: :reviewed)
        reviewed_post, other_user_reviewed_post, published_post = posts

        visit root_path
        click_link "Reviewed"

        expect_page_to_have(
          title: "Reviewed",
          to_have: reviewed_post,
          not_to_have: [published_post, other_user_reviewed_post],
        )
      end
    end

    context "published" do
      it "sees page with his own posts in 'published' status" do
        posts = create_posts(status: :published)
        published_post, other_user_published_post, draft_post = posts

        visit root_path
        click_link "Published"

        expect_page_to_have(
          title: "Published",
          to_have: published_post,
          not_to_have: [draft_post, other_user_published_post],
        )
      end
    end
  end

  def create_posts(status:)
    other_status = (Post::STATUSES - [status.to_s]).first.to_sym
    post = create :post, status.to_sym, user_id: @writer.id
    other_user_post = create :post, status.to_sym
    other_status_post = create :post, other_status, user_id: @writer.id
    [
      post,
      other_user_post,
      other_status_post,
    ]
  end

  def expect_page_to_have(title:, to_have:, not_to_have:)
    within(".main_content") do
      expect(page).to have_content(title)

      Array(to_have).each do |post|
        expect(page).to have_content(post.title)
      end

      Array(not_to_have).each do |post|
        expect(page).not_to have_content(post.title)
      end
    end
  end
end
