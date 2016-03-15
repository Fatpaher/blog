require "rails_helper"

describe CommentsController do
  describe "when user signed in" do
    before :each do
      user = create :user
      sign_in user
    end

    describe "POST #create" do
      context "when name and body present" do
        it "should redirect to post link" do
          written_post = create :post

          post(:create,
               post_id: written_post.id,
               comment: attributes_for(:comment))

          expect(response).to redirect_to(post_path(written_post))
        end

        it "should create new comment" do
          written_post = create :post

          expect do
            post(:create,
                 post_id: written_post.id,
                 comment: attributes_for(:comment))
          end.to change(Comment, :count).by(+1)
        end
      end

      context "when body empty" do
        it "can't create comment" do
          written_post = create :post
          expect do
            post(:create,
                 post_id: written_post.id,
                 comment: attributes_for(:comment, body: ""))
          end.to_not change(Comment, :count)
        end
      end
    end

    describe "DELETE #destroy" do
      it "should redirect_to post link" do
        post = create :post
        comment = create :comment, post_id: post.id

        delete :destroy, post_id: post.id, id: comment.id

        expect(response).to redirect_to(post_path(post))
      end

      it "should destroy requested comment" do
        post = create :post
        comment = create :comment, post_id: post.id

        expect do
          delete :destroy, post_id: post.id, id: comment.id
        end.to change(Comment, :count).by(-1)
      end
    end
  end

  describe "when user not signed in" do
    describe "POST #create" do
      it "can't create new comment" do
        written_post = create :post
        expect do
          post(:create,
               post_id: written_post.id,
               comment: attributes_for(:comment))
        end.to_not change(Comment, :count)
      end
    end

    describe "DELETE #destroy" do
      it "can't delete comments" do
        post = create :post
        comment = create :comment, post_id: post.id

        expect do
          delete :destroy, post_id: post.id, id: comment.id
        end.to_not change(Comment, :count)
      end
    end
  end
end
