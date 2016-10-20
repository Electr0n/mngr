require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "response status" do
    
    context "if USER SIGNED." do
      let(:user) {u = create(:user)}
      before {sign_in user}
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
        it "for valid data responds status 302" do
          t = create(:tag)
          put :update, {id: user.id, user: attributes_for(:user, name: "newname", tags: "Sport")}
          user.reload
          expect(response.status).to eq(302)
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
      end

      context "Destroy action" do
        it "for user!=current_user responds status 403" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response.status).to eq(403)
        end
        it "for user==current_user responds status 200" do
          delete :destroy, id: user.id
          expect(response.status).to eq(200)
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
      before {sign_in user}
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
      end

      context "Destroy action" do
        it "for user!=current_user should render 403 page" do
          u1 = create(:user)
          delete :destroy, id: u1.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "for user==current_user should render index template" do
          delete :destroy, id: user.id
          expect(response).to render_template :index
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
        before {sign_in user}
      
        context "but updating some one's data" do
          it "shouldn't update user" do
            u1 = create(:user)
            put :update, id: u1.id, user: attributes_for(:user, name: "ALIBABA")
            u1.reload
            expect(u1.name).not_to eq("ALIBABA")
          end
        end
        
        context "but input invalid data" do
          it "shouldn't update user" do
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: nil, tags: "Sport")
            user.reload
            expect(user.name).not_to eq("ALIBABA")
            expect(user.email).not_to eq(nil)
            expect(user.tags.count).to eq(0)
          end
        end

        context "and trying to update his prfile with valid data" do
          it "should update user" do
            t = create(:tag)
            put :update, id: user.id, user: attributes_for(:user, name: "ALIBABA", email: "itshould@update.com", tags: "Sport")
            user.reload
            expect(user.name).to eq("ALIBABA")
            expect(user.email).to eq("itshould@update.com")
            expect(user.tags.count).not_to eq(0)
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
        expect{post :create, user: {name: "Ivan", email: "ivan0v@ro.ru", password: "123qwe"}}.to change(User,:count).by(1)
      end
      it "shouldn't save invalid user" do
        expect{post :create, user: {name: "Invalid_user"}}.to change(User,:count).by(0)
      end
    end

    context "Destroy action:" do
      context "if user SIGNED" do
        let(:user) {u = create(:user)}
        before {sign_in user}
        it "shouldn't destroy any users for user!=current_user" do
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
        it "should destroy user for user==current_user" do
          expect{delete :destroy, id: user.id}.to change(User,:count).by(-1)
        end
      end
      context "if user NOT SIGNED" do
        it "shouldn't destroy eny users" do
          u1 = create(:user)
          expect{delete :destroy, id: u1.id}.to change(User,:count).by(0)
        end
      end
    end
  end

  describe "permited attributes" do
    let(:user) {u = create(:user)}
    it "should update name" do
      user.name = "Alibaba"
      expect(user.name).to eq("Alibaba")
    end
    it "should update surname" do
      user.surname = "Alibaba"
      expect(user.surname).to eq("Alibaba")
    end
    it "should update email" do
      user.email = "Go@home.yanki"
      expect(user.email).to eq("Go@home.yanki")
    end
    it "should update birthday" do
      user.bday = "29 Dec 1992"
      expect(user.bday.strftime('%F') ).to eq("1992-12-29")
    end
    it "should update gender" do
      user.gender = "Male"
      expect(user.gender).to eq("Male")
    end
    it "should update age" do
      user.age = "18"
      expect(user.age).to eq(18)
    end
    it "should update phone" do
      user.phone = 291363912
      expect(user.phone).to eq(291363912)
    end
    it "should update hobby" do
      user.hobby = "I love crocodiles"
      expect(user.hobby).to eq("I love crocodiles")
    end
    it "should update about" do
      user.about = "I'm programmer"
      expect(user.about).to eq("I'm programmer")
    end
    it "should update password" do
      user.password = "Alibaba"
      expect(user.password).to eq("Alibaba")
    end
    it "should update password confirmation" do
      user.password_confirmation = "Alibaba"
      expect(user.password_confirmation).to eq("Alibaba")
    end
    it "should update avatar" do
      user.avatar = File.open("#{Rails.root}/public/favicon.ico")
      expect(user.avatar_file_name).to eq("favicon.ico")
    end
    it "should update country" do
      user.country = "BY"
      expect(user.country).to eq("BY")
    end
    it "should update city" do
      user.city = "HM"
      expect(user.city).to eq("HM")
    end
  end

  describe "permited attributes" do
    let(:user) {u = create(:user)}
    before {sign_in user}
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
        role:     "admin",
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
      expect(User.last.role).to eq("admin")
      expect(User.last.tags.last.name).to eq("Sport")
    end
  end
end