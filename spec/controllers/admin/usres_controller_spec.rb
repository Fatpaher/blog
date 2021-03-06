require "rails_helper"

describe UsersController do
  describe "sign in as admin" do
    before :each do
      @admin = create :user, :admin
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
          other_admin = create :user, :admin

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
end
