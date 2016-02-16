require 'rails_helper'

describe PostsController do
  describe 'POST create' do

    context "when user signed in" do
      before :each do
        user = create :user
        sign_in user
      end

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

    context "when user not signed in" do
      it "should redirect to sign in url" do
        post :create, post: {title: 'some title'}

        expect(response).to redirect_to(new_user_session_path)
      end

      it "can't create new post" do
        expect {
          post :create, post: attributes_for(:post)
        }.to_not change(Post, :count)
      end
    end
  end

  describe "DELETE delete" do
    context "when user signed in" do
      before :each do
        user = create :user
        sign_in user
      end
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
    context "when user not signed in" do
      it "should redirect to sign in page" do
        post = create :post

        delete :destroy, id: post.id

        expect(response).to redirect_to(new_user_session_path)
      end

      it "should  destroy the requested post" do
        post = create :post, id:1

        expect {
          delete :destroy, id:post
        }.to_not change(Post, :count)
      end
    end
  end

  describe "PUT update" do
    context "when user signed in" do
      before :each do
        user = create :user
        sign_in user
      end
      it "located requested post" do
        post = create :post

        put :update, id: post, post: attributes_for(:post)

        expect(assigns(:post)).to eq(post)
      end

      context "with valid attributes" do
        it "change post attributes" do
          post = create :post

          put :update, id: post,
            post: attributes_for(:post, title: 'Changed title',
                                  body:'Changed body'
                                )
          post.reload

          expect(post.title).to eq('Changed title')
          expect(post.body).to eq('Changed body')
        end
        it "redirect to updated post" do
          post = create :post

          put :update, id: post, post: attributes_for(:post)

          expect(response).to redirect_to(post)
        end
      end
      context "with invalid parametrs" do
        it "doesn't change post attributes" do
          post = create :post, title: 'Original title'

          put :update, id: post,
            post: attributes_for(:post, title: nil, body:'Changed body')

          expect(post.title).to eq('Original title')
          expect(post.body).to_not eq('Changed body')
        end
        it "re-render edit post path" do
          post = create :post

          put :update, id: post, post: attributes_for(:post, title: nil)

          expect(response).to render_template :edit
        end
      end
    end

    context "when user not signed in" do

      it "can't change post attributes" do
        post = create :post

        put :update, id: post,
          post: attributes_for(:post, title: 'Changed title',
                                body:'Changed body'
                              )
        post.reload

        expect(post.title).to_not eq('Changed title')
        expect(post.body).to_not eq('Changed body')
      end
      it "redirect to sign in page" do
        post = create :post

        put :update, id: post, post: attributes_for(:post)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
