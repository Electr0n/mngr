require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'response/rendering' do

    context 'for signed as:' do

      let(:user)            {create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      let(:role_banned)     {create(:role_banned)}
      before {
          user.roles << role_user
          sign_in user
        }

      context 'SUPERADMIN' do
        before {user.roles << role_superadmin}

        it 'index action should render index template(200)' do
          get :index
          expect(response).to render_template :index
          expect(response.status).to eq(200)
        end

        it 'new action should redirect to users page (302)' do
          get :new
          expect(response).to redirect_to user_path(user)
          expect(response.status).to eq(302)
        end

        it 'edit action should render edit template(200)' do
          u1 = create(:user)
          get :edit, id: u1.id
          expect(response).to render_template :edit
          expect(response.status).to eq(200)
        end

        context 'update action' do
          it 'for valid data should redirect to users page(302)' do
            u1 = create(:user)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname")}
            u1.reload
            expect(response).to redirect_to user_path(u1)
            expect(response.status).to eq(302)
          end
          it 'for invalid data should redirect to edit users page(302)' do
            put :update, {id: user.id, user: attributes_for(:user, email: nil)}
            user.reload
            expect(response).to redirect_to edit_user_path(user)
            expect(response.status).to eq(302)
          end
        end

        it 'show action should render show template(200)' do
          u1 = create(:user)
          get :show, id: u1.id
          expect(response).to render_template :show
          expect(response.status).to eq(200)
        end

        it "destroy action should render index template(200)" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response).to render_template :index
          expect(response.status).to eq(200)
        end

        it "del_request should render deleted page(200)" do
          u1 = create(:user)
          get :del_request, id: u1.id
          expect(response.status).to eq(200)
          expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
        end

        it 'subregion_options should render partial(200)' do
          get :subregion_options, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_subregion_select"
        end
        it 'city_search should render partial(200)' do
          get :city_search, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_q_subregion_select"
        end

      end

      context 'ADMIN' do
        before {user.roles << role_admin}

        it 'index action should render index template(200)' do
          get :index
          expect(response).to render_template :index
          expect(response.status).to eq(200)
        end

        it 'new action should redirect to users page (302)' do
          get :new
          expect(response).to redirect_to user_path(user)
          expect(response.status).to eq(302)
        end

        it 'edit action should render edit template(200)' do
          u1 = create(:user)
          get :edit, id: u1.id
          expect(response).to render_template :edit
          expect(response.status).to eq(200)
        end

        context 'update action' do
          it 'for valid data should redirect to users page(302)' do
            u1 = create(:user)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname")}
            u1.reload
            expect(response).to redirect_to user_path(u1)
            expect(response.status).to eq(302)
          end
          it 'for invalid data should redirect to edit users page(302)' do
            put :update, {id: user.id, user: attributes_for(:user, email: nil)}
            user.reload
            expect(response).to redirect_to edit_user_path(user)
            expect(response.status).to eq(302)
          end
        end

        it 'show action should render show template(200)' do
          u1 = create(:user)
          get :show, id: u1.id
          expect(response).to render_template :show
          expect(response.status).to eq(200)
        end

        it "destroy action should render index template(403)" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it "del_request should render deleted page(200)" do
          u1 = create(:user)
          get :del_request, id: u1.id
          expect(response.status).to eq(200)
          expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
        end

        it 'subregion_options should render partial(200)' do
          get :subregion_options, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_subregion_select"
        end
        it 'city_search should render partial(200)' do
          get :city_search, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_q_subregion_select"
        end

      end

      context 'MODERATOR' do
        before {user.roles << role_moderator}

        it 'index action should render index template(200)' do
          get :index
          expect(response).to render_template :index
          expect(response.status).to eq(200)
        end

        it 'new action should redirect to users page (302)' do
          get :new
          expect(response).to redirect_to user_path(user)
          expect(response.status).to eq(302)
        end

        it 'edit action should render 403 page(403)' do
          u1 = create(:user)
          get :edit, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
          expect(response.status).to eq(403)
        end

        context 'update action' do
          it 'for valid data should render 403 page(403)' do
            u1 = create(:user)
            put :update, {id: u1.id, user: attributes_for(:user, name: "newname")}
            u1.reload
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
            expect(response.status).to eq(403)
          end
          it 'for invalid data should redirect to edit users page(302)' do
            put :update, {id: user.id, user: attributes_for(:user, email: nil)}
            user.reload
            expect(response).to redirect_to edit_user_path(user)
            expect(response.status).to eq(302)
          end
        end

        it 'show action should render show template(200)' do
          u1 = create(:user)
          get :show, id: u1.id
          expect(response).to render_template :show
          expect(response.status).to eq(200)
        end

        it "destroy action should render index template(403)" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it "del_request should render deleted page(200)" do
          u1 = create(:user)
          get :del_request, id: u1.id
          expect(response.status).to eq(200)
          expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
        end

        it 'subregion_options should render partial(200)' do
          get :subregion_options, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_subregion_select"
        end
        it 'city_search should render partial(200)' do
          get :city_search, user_id: user.id
          expect(response.status).to eq(200)
          expect(response).to render_template partial: "_q_subregion_select"
        end

      end

      context 'USER' do
        before {user.roles << role_user}

        context '== current_user' do
          it 'index action should render index template(200)' do
            get :index
            expect(response).to render_template :index
            expect(response.status).to eq(200)
          end

          it 'new action should redirect to users page (302)' do
            get :new
            expect(response).to redirect_to user_path(user)
            expect(response.status).to eq(302)
          end

          it 'edit action should render edit template (200)' do
            get :edit, id: user.id
            expect(response).to render_template :edit
            expect(response.status).to eq(200)
          end

          context 'update action' do
            it 'for valid data should redirect_to users page(302)' do
              put :update, {id: user.id, user: attributes_for(:user, name: "newname")}
              user.reload
              expect(response).to redirect_to user_path(user)
              expect(response.status).to eq(302)
            end
            it 'for invalid data should redirect to edit users page(302)' do
              put :update, {id: user.id, user: attributes_for(:user, email: nil)}
              user.reload
              expect(response).to redirect_to edit_user_path(user)
              expect(response.status).to eq(302)
            end
          end

          it 'show action should render show template(200)' do
            u1 = create(:user)
            get :show, id: u1.id
            expect(response).to render_template :show
            expect(response.status).to eq(200)
          end

          it "destroy action should render index template(403)" do
            u1 = create(:user)
            delete :destroy, id: u1.id
            expect(response.status).to eq(403)
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          end

          it "del_request should render deleted page(200)" do
            get :del_request, id: user.id
            expect(response.status).to eq(200)
            expect(response).to render_template file: "#{Rails.root}/public/system/users/deleted.html"
          end

          it 'subregion_options should render partial(200)' do
            get :subregion_options, user_id: user.id
            expect(response.status).to eq(200)
            expect(response).to render_template partial: "_subregion_select"
          end

          it 'city_search should render partial(200)' do
            get :city_search, user_id: user.id
            expect(response.status).to eq(200)
            expect(response).to render_template partial: "_q_subregion_select"
          end
        end

        context '!= current_user' do

          let(:u1) {create(:user)}

          before {u1}

          it 'index action should render index template(200)' do
            get :index
            expect(response).to render_template :index
            expect(response.status).to eq(200)
          end

          it 'new action should redirect to users page (302)' do
            get :new
            expect(response).to redirect_to user_path(user)
            expect(response.status).to eq(302)
          end

          it 'edit action should render 403 page(403)' do
            get :edit, id: u1.id
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
            expect(response.status).to eq(403)
          end

          context 'update action' do
            it 'for valid data should render 403 page(403)' do
              put :update, {id: u1.id, user: attributes_for(:user, name: "newname")}
              u1.reload
              expect(response).to render_template file: "#{Rails.root}/public/403.html"
              expect(response.status).to eq(403)
            end
            it 'for invalid data should render 403 page(403)' do
              put :update, {id: u1.id, user: attributes_for(:user, email: nil)}
              u1.reload
              expect(response.status).to eq(403)
              expect(response).to render_template file: "#{Rails.root}/public/403.html"
            end
          end

          it 'show action should render show template(200)' do
            get :show, id: u1.id
            expect(response).to render_template :show
            expect(response.status).to eq(200)
          end

          it "destroy action should render index template(403)" do
            delete :destroy, id: u1.id
            expect(response.status).to eq(403)
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          end

          it "del_request should render 403 page(403)" do
            get :del_request, id: u1.id
            expect(response.status).to eq(403)
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          end

          it 'subregion_options should render partial(200)' do
            get :subregion_options, user_id: u1.id
            expect(response.status).to eq(200)
            expect(response).to render_template partial: "_subregion_select"
          end

          it 'city_search should render partial(200)' do
            get :city_search, user_id: u1.id
            expect(response.status).to eq(200)
            expect(response).to render_template partial: "_q_subregion_select"
          end
        end

      end
      context 'BANNED' do
        before {user.roles << role_banned}

        it "Index action should render index template (200)" do
          get :index
          expect(response).to render_template :index
          expect(response.status).to eq(200)
        end

        it "New action should redirect to users page(302)" do
          get :new
          expect(response).to redirect_to user_path(user)
          expect(response.status).to eq(302)
        end

        it "Edit action should render 403 page(403)" do
          get :edit, id: user.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
          expect(response.status).to eq(403)
        end

        it "Update action should render 403 page(403)" do
          put :update, {id: user.id, user: attributes_for(:user, name: "newname")}
          user.reload
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
          expect(response.status).to eq(403)
        end

        context "Show action" do
          it "should render 404 page if user.nil? (404)" do
            get :show, id: User.count+1
            expect(response.status).to eq(404)
            expect(response).to render_template file: "#{Rails.root}/public/404.html"
          end
          it "should render users page(200)" do
            get :show, id: user.id
            expect(response.status).to eq(200)
            expect(response).to render_template :show
          end
        end

        it "Destroy action should render 403 page(403)" do
          delete :destroy, id: user.id
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          expect(response.status).to eq(403)
        end

        it "del_request should render 403 page (403)" do
          get :del_request, id: user.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
          expect(response.status).to eq(403)
        end
      end

    end

    context 'unsigned' do

      let(:u) {create(:user)}

      before {u}

      it "Index action should redirect to sign in page(302)" do
        get :index
        expect(response).to redirect_to new_user_session_path
        expect(response.status).to eq(302)
      end

      it "New action should render new template(200)" do
        get :new
        expect(response).to render_template :new
        expect(response.status).to eq(200)
      end

      context "Create action" do
        it "for valid user should redirect to users page(302)" do
          create(:role_user)
          post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}
          expect(response).to redirect_to assigns(:user)
          expect(response.status).to eq(302)
        end
        it "for invalid user should render new template(200)" do
          u = build(:invalid_user)
          post :create, user: u.attributes
          expect(response).to render_template :new
          expect(response.status).to eq(200)
        end
      end

      it "Edit action should redirect to new user page(302)" do
        get :edit, id: u.id
        expect(response).to redirect_to new_user_session_path
        expect(response.status).to eq(302)
      end

      it "Update action should redirect to new user page(302)" do
        put :update, {id: u.id, user: attributes_for(:user, name: "newname")}
        u.reload
        expect(response).to redirect_to new_user_session_path
        expect(response.status).to eq(302)
      end

      context "Show action" do
        it "should render 404 page if user.nil? (404)" do
          get :show, id: User.count+1
          expect(response.status).to eq(404)
          expect(response).to render_template file: "#{Rails.root}/public/404.html"
        end
        it "should render users page(200)" do
          get :show, id: u.id
          expect(response.status).to eq(200)
          expect(response).to render_template :show
        end
      end

      it "Destroy action should render sign_in template(302)" do
        delete :destroy, id: u.id
        expect(response).to redirect_to new_user_session_path
        expect(response.status).to eq(302)
      end

      it "del_request should render 403 page (403)" do
        get :del_request, id: u.id
        expect(response).to render_template file: "#{Rails.root}/public/403.html"
        expect(response.status).to eq(403)
      end
    end

  end
  
  describe "Logic" do

    context "Action update" do
      
      context "if USER SIGNED" do
      
        let(:user)            {create(:user)}
        let(:role_user)       {create(:role_user)}
        let(:role_superadmin) {create(:role_superadmin)}
        let(:role_admin)      {create(:role_admin)}
        let(:role_moderator)  {create(:role_moderator)}
        let(:role_banned)     {create(:role_banned)}
        before {
          user.roles << role_user
          sign_in user
        }

        context "but input invalid data" do
          it "shouldn't update user" do
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: nil)
            user.reload
            expect(user.name).not_to eq("ALIBABA")
            expect(user.email).not_to eq(nil)
            expect(user.tags.count).to eq(0)
          end
        end

        context "and trying to update profile with valid data" do
          
          let(:t) {create(:tag)}
          before {
            t
          }

          it "shouldn't update user for USER!=current_user" do
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA")
            u1.reload
            expect(u1.name).not_to eq("ALIBABA")
          end

          it 'shouldnt update user if BANNED' do
            user.roles << role_banned
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA")
            user.reload
            expect(user.name).not_to eq("ALIBABA")
          end

          it "should update user" do
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: ["Sport"])
            user.reload
            expect(user.name).to eq("ALIBABA")
            expect(user.email).to eq("itshould@update.com")
            expect(user.tags.count).not_to eq(0)
          end

          it "should update user's tags with uniq data" do
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: ["Sport", "Sport", "Sport", ""])
            user.reload
            expect(user.tags.count).to eq(1)
          end

          it "as SUPERADMIN, should update user" do
            user.roles.delete(role_user)
            user.roles << role_superadmin
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: ["Sport"])
            u1.reload
            expect(u1.name).to eq("ALIBABA")
            expect(u1.email).to eq("itshould@update.com")
            expect(u1.tags.count).not_to eq(0)
          end

          it "as ADMIN, should update user" do
            user.roles.delete(role_user)
            user.roles << role_admin
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: ["Sport"])
            u1.reload
            expect(u1.name).to eq("ALIBABA")
            expect(u1.email).to eq("itshould@update.com")
            expect(u1.tags.count).not_to eq(0)
          end

          it "as MODERATOR, shouldn't update user" do
            user.roles.delete(role_user)
            user.roles << role_moderator
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: ["Sport"])
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
          put :update, id: u.id, user: attributes_for(:user, name: "ALIBABA")
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
        let(:user)            {create(:user)}
        let(:role_user)       {create(:role_user)}
        let(:role_superadmin) {create(:role_superadmin)}
        let(:role_admin)      {create(:role_admin)}
        let(:role_moderator)  {create(:role_moderator)}
        let(:role_banned)     {create(:role_banned)}
        before {
          user.roles << role_user
          sign_in user
        }
        it "shouldn't destroy any users for user!=current_user" do
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
        it "should not destroy any users for USER==current_user" do
          expect{delete :destroy, id: user.id}.to change(User,:count).by(0)
        end
        it "should not destroy any users if BANNED" do
          user.roles << role_banned
          expect{delete :destroy, id: user.id}.to change(User,:count).by(0)
        end
        it "for SUPERADMIN should destroy any user" do
          user.roles << role_superadmin
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(-1)
        end
        it "for ADMIN should not destroy any users" do
          user.roles << role_admin
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
        it "for MODERATOR should not destroy any users" do
          user.roles << role_moderator
          u1 = create(:user)
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
        let(:user)            {create(:user)}
        let(:role_user)       {create(:role_user)}
        let(:role_superadmin) {create(:role_superadmin)}
        let(:role_admin)      {create(:role_admin)}
        let(:role_moderator)  {create(:role_moderator)}
        let(:role_banned)     {create(:role_banned)}
        before {
          user.roles << role_user
          sign_in user
        }
        it "should not change del_flag for user!=current_user" do
          u1 = create(:user)
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(false)
        end
        it "should not change del_flag if BANNED" do
          user.roles << role_banned
          get :del_request, id: user.id
          user.reload
          expect(user.del_flag).to eq(false)
        end
        it "should set del_flag by true for user==current_user" do
          get :del_request, id: user.id
          user.reload
          expect(user.del_flag).to eq(true)
        end
        it "should set del_flag by true for SUPERADMIN" do
          user.roles << role_superadmin
          u1 = create(:user)
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(true)
        end
        it "should set del_flag by true for ADMIN" do
          user.roles << role_admin
          u1 = create(:user)
          get :del_request, id: u1.id
          u1.reload
          expect(u1.del_flag).to eq(true)
        end
        it "should set del_flag by true for MODERATOR" do
          user.roles << role_moderator
          u1 = create(:user)
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
    let(:user)            {create(:user)}
    let(:role_user)       {create(:role_user)}
    before {
      user.roles << role_user
      sign_in user
    }
    it "should update user params" do
      t = create(:tag)
      put :update, id: user.id, user: attributes_for(
        :user,
        name:               "realy_valid",
        surname:            "RLYRLY",
        email:              "hoho@haha.com",
        password:           "asdzxc",
        bday:               "1992-12-29",
        gender:             "female",
        country:            "BY",
        city:               "HM",
        hobby:              "something",
        about:              "interesting",
        del_flag:           "true",
        tags:               ["Sport"],
        phones_attributes:  {"0"=>{"code"=>"111", "number"=>"222222222", "description"=>"mts", "_destroy"=>"false", "id"=>"1"}, "1"=>{"code"=>"555", "number"=>"66663666", "description"=>"life", "_destroy"=>"false", "id"=>"2"}}
        )
      user.reload
      expect(User.last.name).to eq("realy_valid")
      expect(User.last.surname).to eq("RLYRLY")
      expect(User.last.email).to eq("hoho@haha.com")
      expect(User.last.bday.strftime('%F')).to eq("1992-12-29")
      expect(User.last.gender).to eq("female")
      expect(User.last.country).to eq("BY")
      expect(User.last.city).to eq("HM")
      expect(User.last.hobby).to eq("something")
      expect(User.last.about).to eq("interesting")
      expect(User.last.del_flag).to eq(true)
      expect(User.last.tags.last.name).to eq("Sport")
      expect(User.last.phones.count).to eq(2)
    end
    it "should update avatar" do
      user.avatar = File.open("#{Rails.root}/public/favicon.ico")
      expect(user.avatar_file_name).to eq("favicon.ico")
    end
  end
end