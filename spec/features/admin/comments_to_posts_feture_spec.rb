require "rails_helper"

feature "User leave comment to post" do
  context "signed in as admin" do
    before :each do
      @admin = create :user, :admin
      login_as @admin
    end

    it "can delete all other comments" do
      comment = create :comment

      visit post_path(comment.post)

      expect(page).to have_css(".del-comment", "Delete")
    end
  end
end
