require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "response status" do
    
    context "if USER SIGNED." do
      let(:user) {u = create(:user)}
      let(:role) {r = create(:role_user)}
      before {
        user.roles << role
        sign_in user
      }
      it "Index action responds status 200" do
        get :index
        expect(response.status).to eq(200)
      end
      it "New action responds status 302" do
        get :new
        expect(response.status).to eq(302)
      end
      
      context "Update action" do
        it "if user!=current_user responds status 403" do
          u1 = create(:user)
          put :update, {id: u1.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
          u1.reload
          expect(response.status).to eq(403)
        end
        describe "for valid data responds status 302" do
          it "if USER=current_user" do
            t = create(:tag)
            put :update, {id: user.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
            user.reload
            expect(response.status).to eq(302)
          end
          it "if SUPERADMIN" do
            r1 = create(:role_superadmin)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
            u1.reload
            expect(response.status).to eq(302)
          end
          it "if ADMIN" do
            r1 = create(:role_admin)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
            u1.reload
            expect(response.status).to eq(302)
          end
          it "if MODERATOR" do
            r1 = create(:role_moderator)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
            u1.reload
            expect(response.status).to eq(403)
          end          
        end
        it "for invalid data responds status 302" do
          put :update, {id: user.id, user: attributes_for(:user, email: nil, tags: "Sport")}
          user.reload
          expect(response.status).to eq(302)
        end
      end
      
      context "Edit action" do
        it "for user==current_user responds status 200" do
          get :edit, id: user.id
          expect(response.status).to eq(200)
        end
        it "for user!=current_user responds status 403" do
          u1 = create(:user)
          get :edit, id: u1.id
          expect(response.status).to eq(403)
        end
        it "for SUPERADMIN responds status 200" do
          r1 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response.status).to eq(200)
        end
        it "for ADMIN responds status 200" do
          r1 = create(:role_admin)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response.status).to eq(200)
        end
        it "for MODERATOR responds status 403" do
          r1 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response.status).to eq(403)
        end
      end

      context "Destroy action" do
        it "for user!=current_user responds status 403" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
        end
        it "for USER==current_user responds status 403" do
          delete :destroy, id: user.id
          expect(response.status).to eq(403)
        end
        it "for SUPERADMIN responds status 200" do
          r2 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response.status).to eq(200)
        end
        it "for ADMIN responds status 403" do
          r2 = create(:role_admin)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
        end
        it "for MODERATOR responds status 403" do
          r2 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
        end
      end

      describe "del_request action" do
        it "for user==current_user should responds status 200" do
          get :del_request, id: user.id
          expect(response.status).to eq(200)
        end
        describe "for user!=current_user:" do
          it "role SUPERADMIN should responds status 200" do
            r1 = create(:role_superadmin)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response.status).to eq(200)
          end
          it "role ADMIN should responds status 200" do
            r1 = create(:role_admin)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response.status).to eq(200)
          end
          it "role MODERATOR should responds status 200" do
            r1 = create(:role_moderator)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response.status).to eq(200)
          end
          it "role USER should responds status 403" do
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response.status).to eq(403)
          end
        end
      end
    end

    context "if USER NOT SIGNED." do
      it "Index action responds status 302" do
        get :index
        expect(response.status).to eq(302)
      end
      it "New action responds status 200" do
        get :new
        expect(response.status).to eq(200)
      end
      it "Update action responds 302" do
        u = create(:user)
        put :update, {id: u.id, user: attributes_for(:user, name: "newname")}
        u.reload
        expect(response.status).to eq(302)
      end

      context "Create action" do
        it "for valid user responds status 302" do
          r = create(:role_user)
          post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}
          expect(response.status).to eq(302)
        end
        it "for invalid user responds status 200" do
          post :create, user: {name: "Invalid_user"}
          expect(response.status).to eq(200)
        end
      end

      context "Edit action" do
        it "should responds status 302" do
          u = create(:user)
          get :edit, id: u.id
          expect(response.status).to eq(302)
        end
      end

      context "Show action" do
        it "should responds status 404" do
          get :show, id: User.count+1
          expect(response.status).to eq(404)
        end
        it "should responds status 200" do
          u = create(:user)
          get :show, id: u.id
          expect(response.status).to eq(200)
        end
      end

      it "Destroy action responds status 302" do
        u = create(:user)
        get :destroy, id: u.id
        expect(response.status).to eq(302)
      end
    end
  end
  
  describe "template rendering." do

    context "if USER SIGNED." do
      let(:user) {u = create(:user)}
      let(:role) {r = create(:role_user)}
      before {
        user.roles << role
        sign_in user
      }
      it "Index action should render index template" do
        get :index
        expect(response).to render_template :index
      end
      it "New action should render new template" do
        get :new
        expect(response).to redirect_to user_path(user)
      end

      context "Update action" do
        it "for user!==current_user should render to 403 page" do
          u1 = create(:user)
          put :update, {id: u1.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
          u1.reload
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for user==current_user should redirect to user's page" do
          t = create(:tag)
          put :update, {id: user.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
          user.reload
          expect(response).to redirect_to user_path(user)
        end
        it "for valid data should redirect to user's edit page" do
          put :update, {id: user.id, user: attributes_for(:user, email: nil, tags: "Sport")}
          user.reload
          expect(response).to redirect_to edit_user_path(user)
        end
      end
      
      context "Edit action" do
        it "for user!=current_user should render 403 page" do
          u1 = create(:user)
          get :edit, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for user==current_user should render edit template" do
          get :edit, id: user.id
          expect(response).to render_template :edit
        end
        it "for SUPERADMIN should render edit template" do
          r1 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response).to render_template :edit
        end
        it "for ADMIN should render edit template" do
          r1 = create(:role_admin)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response).to render_template :edit
        end
        it "for MODERATOR should render 403 page" do
          r1 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r1
          get :edit, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context "Destroy action" do
        it "for user!=current_user should render 403 page" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for user==current_user should render 403" do
          delete :destroy, id: user.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for SUPERADMIN render index template" do
          r2 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response).to render_template :index
        end
        it "for ADMIN should render 403" do
          r2 = create(:role_admin)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for MODERATOR should render 403" do
          r2 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r2
          delete :destroy, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      describe "del_request action" do
        it "for user==current_user should render deleted page" do
          get :del_request, id: user.id
          expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
        end
        describe "for user!=current_user:" do
          it "role SUPERADMIN should render deleted page" do
            r1 = create(:role_superadmin)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
          end
          it "role ADMIN should render deleted page" do
            r1 = create(:role_admin)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
          end
          it "role MODERATOR should render deleted page" do
            r1 = create(:role_moderator)
            user.roles << r1
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
          end
          it "role USER should render 403 page" do
            u1 = create(:user)
            get :del_request, id: u1.id
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          end
        end
      end
    end

    context "if USER NOT SIGNED." do
      it "Index action should redirect to sign in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
      it "New action should render new template" do
        get :new
        expect(response).to render_template :new
      end
      it "Update action should redirect to" do
        u = create(:user)
        put :update, {id: u.id, user: attributes_for(:user, name: "newname")}
        u.reload
        expect(response).to redirect_to new_user_session_path
      end

      context "Create action:" do
        it "for valid user should redirect to user's page" do
          r = create(:role_user)
          post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}
          expect(response).to redirect_to assigns(:user)
        end
        it "for invalid user should render new template" do
          u = build(:invalid_user)
          post :create, user: u.attributes
          expect(response).to render_template :new
        end
      end

      it "Edit action" do
        u = create(:user)
        get :edit, id: u.id
        expect(response).to redirect_to new_user_session_path
      end

      context "Show action" do
        it "should render 404 page" do
          get :show, id: User.count+1
          expect(response).to render_template file: "#{Rails.root}/public/404.html"
        end
        it "should render user's page" do
          u = create(:user)
          get :show, id: u.id
          expect(response).to render_template :show
        end
      end

      it "Destroy action should render sign_in template" do
        u = create(:user)
        delete :destroy, id: u.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "Logic" do

    context "Action update" do
      
      context "if USER SIGNED" do
      
        let(:user) {u = create(:user)}
        let(:role) {r = create(:role_user)}
        before {
          user.roles << role
          sign_in user
        }

        context "but input invalid data" do
          it "shouldn't update user" do
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: nil, tags: "Sport")
            user.reload
            expect(user.name).not_to eq("ALIBABA")
            expect(user.email).not_to eq(nil)
            expect(user.tags.count).to eq(0)
          end
        end

        context "and trying to update profile with valid data" do
          it "shouldn't update user for USER!=current_user" do
            t = create(:tag)
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", tags: "Sport")
            u1.reload
            expect(u1.name).not_to eq("ALIBABA")
          end
          it "should update user" do
            t = create(:tag)
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: "Sport")
            user.reload
            expect(user.name).to eq("ALIBABA")
            expect(user.email).to eq("itshould@update.com")
            expect(user.tags.count).not_to eq(0)
          end
          it "as SUPERADMIN, should update user" do
            r1 = create(:role_superadmin)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: "Sport")
            u1.reload
            expect(u1.name).to eq("ALIBABA")
            expect(u1.email).to eq("itshould@update.com")
            expect(u1.tags.count).not_to eq(0)
          end
          it "as ADMIN, should update user" do
            r1 = create(:role_admin)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: "Sport")
            u1.reload
            expect(u1.name).to eq("ALIBABA")
            expect(u1.email).to eq("itshould@update.com")
            expect(u1.tags.count).not_to eq(0)
          end
          it "as MODERATOR, shouldn't update user" do
            r1 = create(:role_moderator)
            user.roles << r1
            u1 = create(:user)
            t = create(:tag)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: "Sport")
            u1.reload
            expect(u1.name).not_to eq("ALIBABA")
            expect(u1.email).not_to eq("itshould@update.com")
            expect(u1.tags.count).to eq(0)
          end
        end
      end

      context "if USER NOT SIGNED" do
        it "shouldn't update user" do
          u = create(:user)
          put :update, id: u.id, user: attributes_for(:user, name: "ALIBABA", tags: "Sport")
          u.reload
          expect(u.name).not_to eq("ALIBABA")
        end
      end
    end

    context "Action create:" do
      it "should save valid user" do
        r = create(:role_user)
        expect{post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}}.to change(User,:count).by(1)
      end
      it "shouldn't save invalid user" do
        expect{post :create, user: {name: "Invalid_user"}}.to change(User,:count).by(0)
      end
      it "should make user with at least one role" do
        r = create(:role_user)
        post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}
        expect(User.last.roles.count).to eq(1)
      end
    end

    context "Destroy action:" do
      context "if user SIGNED" do
        let(:user) {u = create(:user)}
        let(:role) {r = create(:role_user)}
        before {
          user.roles << role
          sign_in user
        }
        it "shouldn't destroy any users for user!=current_user" do
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
        it "should not destroy any users for USER==current_user" do
          expect{delete :destroy, id: user.id}.to change(User,:count).by(0)
        end
        it "for SUPERADMIN should destroy any user" do
          r2 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r2
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(-1)
        end
        it "for ADMIN should not destroy any users" do
          r2 = create(:role_admin)
          u1 = create(:user)
          user.roles << r2
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
        it "for MODERATOR should not destroy any users" do
          r2 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r2
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
      end
      context "if user NOT SIGNED" do
        it "shouldn't destroy eny users" do
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
      end
    end

    context "del_request action" do
      context "if SIGNED" do
        let(:user) {u = create(:user)}
        let(:role) {r = create(:role_user)}
        before {
          user.roles << role
          sign_in user
        }
        it "should not change del_flag for user!=current_user" do
          u1 = create(:user)
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(false)
        end
        it "should set del_flag by true for user==current_user" do
          get :del_request, id: user.id
          user.reload
          expect(user.del_flag).to eq(true)
        end
        it "should set del_flag by true for SUPERADMIN" do
          r2 = create(:role_superadmin)
          u1 = create(:user)
          user.roles << r2
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(true)
        end
        it "should set del_flag by true for ADMIN" do
          r2 = create(:role_admin)
          u1 = create(:user)
          user.roles << r2
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(true)
        end
        it "should set del_flag by true for MODERATOR" do
          r2 = create(:role_moderator)
          u1 = create(:user)
          user.roles << r2
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(true)
        end
      end

      context "if NOT SIGNED" do
        it "should not change del_flag for any user" do
          u1 = create(:user)
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(false)
        end
      end
    end
  end

  describe "permited attributes" do
    let(:user) {u = create(:user)}
    let(:role) {r = create(:role_user)}
    before {
      user.roles << role
      sign_in user
    }
    it "should update user params" do
      t = create(:tag)
      put :update, id: user.id, user: attributes_for(
        :user,
        name:     "realy_valid",
        surname:  "RLYRLY",
        email:    "hoho@haha.com",
        password: "asdzxc",
        bday:     "1992-12-29",
        gender:   "female",
        age:      "40",
        phone:    "291363913",
        country:  "BY",
        city:     "HM",
        hobby:    "something",
        about:    "interesting",
        del_flag: "true",
        tags:     "Sport"
        )
      user.reload
      expect(User.last.name).to eq("realy_valid")
      expect(User.last.surname).to eq("RLYRLY")
      expect(User.last.email).to eq("hoho@haha.com")
      expect(User.last.bday.strftime('%F')).to eq("1992-12-29")
      expect(User.last.gender).to eq("female")
      expect(User.last.age).to eq(40)
      expect(User.last.phone).to eq(291363913)
      expect(User.last.country).to eq("BY")
      expect(User.last.city).to eq("HM")
      expect(User.last.hobby).to eq("something")
      expect(User.last.about).to eq("interesting")
      expect(User.last.del_flag).to eq(true)
      expect(User.last.tags.last.name).to eq("Sport")
    end
    it "should update avatar" do
      user.avatar = File.open("#{Rails.root}/public/favicon.ico")
      expect(user.avatar_file_name).to eq("favicon.ico")
    end
  end
end