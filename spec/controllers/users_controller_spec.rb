require "rails_helper"

describe UsersController do
  describe "sign in as admin" do
    before :each do
      @admin = create :admin
      sign_in @admin
    end

    describe "GET #index" do
      it "renders index template" do
        get :index

        expect(response).to render_template :index
      end
    end

    describe "GET #show" do
      it "renders show template" do
        get :show, id: @admin
        expect(response).to render_template :show
      end
    end

    describe "DELETE #destroy" do
      context "own profile" do
        it "can't delete own profile" do
          expect do
            delete :destroy, id: @admin
          end.to_not change(User, :count)
        end
      end

      context "other admin profile" do
        it "can't delete other admin profile" do
          other_admin = create :admin

          expect do
            delete :destroy, id: other_admin
          end.to_not change(User, :count)
        end
      end

      context "user profile" do
        it "delete profile" do
          user = create :user

          expect do
            delete :destroy, id: user
          end.to change(User, :count).by(-1)
        end

        it "redirect to user index" do
          user = create :user

          delete :destroy, id: user

          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe "sign in as user" do
    before :each do
      @user = create :user
      sign_in @user
    end

    describe "GET #index" do
      it "redirect to root page" do
        get :index

        expect(response).to redirect_to root_path
      end
    end

    describe "GET #show" do
      describe "when user open his own profile" do
        it "renders show template" do
          get :show, id: @user

          expect(response).to render_template :show
        end
      end

      describe "when user open other user's profile" do
        it "redirect to root path" do
          other_user = create :user

          get :show, id: other_user

          expect(response).to redirect_to root_path
        end
      end
    end
    describe "DELETE #destroy" do
      context "own profile" do
        it "deletes user" do
          expect do
            delete :destroy, id: @user
          end.to change(User, :count).by(-1)
        end

        it "redirect to root_path" do
          delete :destroy, id: @user

          expect(response).to redirect_to root_path
        end
      end

      context "other user profile" do
        it "can't delete" do
          other_user = create :user
          expect do
            delete :destroy, id: other_user
          end.to_not change(User, :count)
        end
        it "redirect_to user path" do
          other_user = create :user
          delete :destroy, id: other_user

          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "not signed in" do
    describe "GET #index" do
      it "redirect to login page" do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET #show" do
      it "redirect_to login page" do
        user = create :user

        get :show, id: user

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
