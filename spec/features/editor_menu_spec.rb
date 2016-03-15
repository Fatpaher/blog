require "rails_helper"

describe "user role eq 'editor'" do
  before :each do
    @editor = create :user, :editor
    login_as @editor
  end

  describe "visit root_path" do
    it "sees editor menu" do
      visit root_path
      expect(page).to have_content("Editor menu")
      expect(page).to have_content("Waiting for review")
      expect(page).to have_content("Reviewed")
      expect(page).to have_content("Published")
    end

    context "waiting for review" do
      it "sees page with all posts with'pending' status" do
        posts = create_posts(status: :pending)
        other_user_pending_post, published_post = posts

        visit root_path
        click_link "Waiting for review"

        expect_page_to_have(
          title: "Waiting for review",
          to_have: other_user_pending_post,
          not_to_have: published_post,
        )
      end
    end

    context "reviewed" do
      it "sees page with all posts with 'reviewed' status" do
        posts = create_posts(status: :reviewed)
        other_user_reviewed_post, published_post = posts

        visit root_path
        click_link "Reviewed"

        expect_page_to_have(
          title: "Reviewed",
          to_have: other_user_reviewed_post,
          not_to_have: published_post,
        )
      end
    end
  end

  def create_posts(status:)
    other_status = (Post::STATUSES - [status.to_s]).first.to_sym
    other_user_post = create :post, status.to_sym
    other_status_post = create :post, other_status, user_id: @editor.id
    [
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
