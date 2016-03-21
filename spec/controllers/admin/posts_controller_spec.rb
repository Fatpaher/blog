require "rails_helper"

describe Admin::PostsController do

  shared_examples "can create posts" do
    context "when title present" do
      it "should redirect to post url" do
        post :create, post: { title: "some title" }

        expect(response).to redirect_to(post_path(1))
      end

      it "should create a new post" do
        expect do
          post :create, post: attributes_for(:post)
        end.to change(Post, :count).by(+1)
      end

      it "assigns current user to post" do
        expect do
          post :create, post: attributes_for(:post)
        end.to change { controller.current_user.posts.count }.by(1)
      end
    end

    context "when title is empty" do
      it "should render new" do
        post :create, post: { title: "" }

        expect(response).to render_template("new")
      end
    end
  end
  shared_examples "can delete his own post" do
    it "should render new" do
      post = create :post, user_id: @user

      delete :destroy, id: post

      expect(response).to redirect_to(root_path)
    end

    it "should  destroy the requested post" do
      post = create :post, user_id: @user.id

      expect do
        delete :destroy, id: post.id
      end.to change(Post, :count).by(-1)
    end
  end


  describe "when user signed in as admin" do
    before :each do
      @user = create :user, :admin
      sign_in @user
    end
    describe "POST #create" do
      it_behaves_like "can create posts"
    end

    describe "DELETE #destroy" do
      it_behaves_like "can delete his own post"

      context "can delete other user post" do
        it "can delete other user post" do
          other_user_post = create :post

          delete :destroy, id: other_user_post

          expect(response.status).to eq(302)
        end

        it "should  destroy the requested post" do
          other_user_post = create :post

          expect do
            delete :destroy, id: other_user_post
          end.to change(Post, :count).by(-1)
        end
      end
    end

    describe "PUT #update" do
      it "located requested post" do
        post = create :post, user_id: @user.id

        put :update, id: post, post: attributes_for(:post)

        expect(assigns(:post)).to eq(post)
      end

      context "with valid attributes" do
        it "change post attributes" do
          post = create :post, user_id: @user.id

          put :update, id: post,
                       post: attributes_for(:post, title: "Changed title",
                                                   body:  "Changed body")
          post.reload

          expect(post.title).to eq("Changed title")
          expect(post.body).to eq("Changed body")
        end

        it "redirect to updated post" do
          post = create :post, user_id: @user.id

          put :update, id: post, post: attributes_for(:post)

          expect(response).to redirect_to(post)
        end
      end

      context "with invalid parametrs" do
        it "doesn't change post attributes" do
          post = create :post, title: "Original title"

          put :update, id: post,
                       post: attributes_for(:post, title: nil,
                                                   body: "Changed body")

          expect(post.title).to eq("Original title")
          expect(post.body).to_not eq("Changed body")
        end

        it "re-render edit post path" do
          post = create :post, user_id: @user.id

          put :update, id: post, post: attributes_for(:post, title: nil)

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "when user signed in as writer" do
    before :each do
      @user = create :user, :writer
      sign_in @user
    end

    describe "POST #create" do
      it_behaves_like "can create posts"
    end

    describe "DELETE #destroy" do
      it_behaves_like "can delete his own post"

      context "can't delete other user post" do
        it "should't destroy the requested post" do
          other_user_post = create :post

          expect do
            delete :destroy, id: other_user_post
          end.to_not change(Post, :count)
        end
      end
    end
  end

  describe "when user not signed in" do
    describe "POST #create" do
      it "should redirect to sign in url" do
        post :create, post: { title: "some title" }

        expect(response).to redirect_to(new_user_session_path)
      end

      it "can't create new post" do
        expect do
          post :create, post: attributes_for(:post)
        end.to_not change(Post, :count)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to sign in page" do
        post = create :post

        delete :destroy, id: post.id

        expect(response).to redirect_to(new_user_session_path)
      end

      it "can't  destroy the requested post" do
        post = create :post, id: 1

        expect do
          delete :destroy, id: post
        end.to_not change(Post, :count)
      end
    end

    describe "PUT #update" do
      it "can't change post attributes" do
        post = create :post

        put :update, id: post,
                     post: attributes_for(:post, title: "Changed title",
                                                 body:  "Changed body")
        post.reload

        expect(post.title).to_not eq("Changed title")
        expect(post.body).to_not eq("Changed body")
      end

      it "redirect to sign in page" do
        post = create :post

        put :update, id: post, post: attributes_for(:post)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
