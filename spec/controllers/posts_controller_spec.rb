require 'rails_helper'

describe PostsController do
  describe 'POST create' do
    context "when title present" do
      it "should redirect to post url" do
        post :create, post: {title: 'some title'}

        expect(response).to redirect_to(post_path(1))
      end

      it "should create a new post" do
        expect {
          post :create, post: attributes_for(:post)
        }.to change(Post, :count).by(+1)
      end
    end

    context "when title is empty" do
      it "should render new" do
        post :create, post: {title: ''}

        expect(response).to render_template('new')
      end
    end
  end

  describe "DELETE delete" do
    it "should render new" do
      post = create :post

      delete :destroy, id: post.id

      expect(response).to redirect_to(root_path)
    end

    it "should  destroy the requested post" do
      post = create :post, id:1

      expect {
        delete :destroy, id:post
      }.to change(Post, :count).by(-1)
    end
  end
end
