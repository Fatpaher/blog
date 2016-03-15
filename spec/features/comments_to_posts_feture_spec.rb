require "rails_helper"

feature "User leave comment to post" do
  context "user signed in" do
    before :each do
      @user = create :user
      login_as @user
    end

    it "can leave a new comment" do
      post = create :post

      visit post_path(post)

      fill_in "Name", with: "Name"
      fill_in "Body", with: "Comment text"
      click_button "Create Comment"

      expect(page).to have_content("Name")
      expect(page).to have_content("Comment text")
      expect(page).to have_content("Comment added.")
    end

    it "can delete comment his own comments" do
      pending
      comment = create :comment, id: @user

      visit post_path(comment.post)
      click_button("Delete comment")

      expect(page).to_not have_content(comment.name)
      expect(page).to_not have_content(comment.body)
      expect(page).to have_content("Comment deleted")
    end

    it "cant't delete other users comment" do
      comment = create :comment

      visit post_path(comment.post)

      expect(page).to_not have_css("del_comment", "Delete")
    end
  end

  context "user not signed in" do
    it "can't leave a comment" do
      post = create :post

      visit post_path(post)

      expect(page).to_not have_content("Add a comment")
      expect(page).to_not have_content("Name")
      expect(page).to_not have_content("Comment text")
      expect(page).to have_content("You should sign in to leave a comment")
    end

    it "can't delete a comment" do
      comment = create :comment

      visit post_path(comment.post)

      expect(page).to_not have_css("del_comment", "Delete")
    end
  end
end