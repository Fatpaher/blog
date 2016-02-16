require 'rails_helper'

describe CommentsController do
  describe "POST #create" do
   context "when name and body present" do
     it "should redirect to post link" do
       written_post = create :post

       post :create, post_id: written_post.id, comment: attributes_for(:post)

       expect(response).to redirect_to(post_path(written_post))
     end
     it "should create new comment" do
       written_post = create :post

       expect {
         post :create, post_id: written_post.id, comment: attributes_for(:post)
       }.to change(Comment, :count).by(+1)
     end
   end
  end

  describe "DELETE destroy" do
    it "should redirect_to post link" do
      post = create :post
      comment = create :comment, post_id: post.id

      delete :destroy, post_id: post.id, id:comment.id

      expect(response).to redirect_to(post_path(post))
    end
    it "should destroy requested comment" do
      post = create :post
      comment = create :comment, post_id: post.id

      expect {
        delete :destroy, post_id: post.id, id:comment.id
      }.to change(Comment, :count).by(-1)
    end
  end
end
