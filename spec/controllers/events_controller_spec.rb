require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "Action responses" do
    context "if user SIGNED" do
      let(:user) {u = create(:user)}
      before {sign_in user}
      
      it "New action responds 200" do
        get :new
        expect(response.status).to eq(200)
      end
      
      context "Create action" do
        it "for valid event responds status 302" do
          e = build(:event)
          post :create, event: e.attributes
          expect(response.status).to eq(302)
        end
        it "for invalid event responds status 200" do
          e = build(:_event)
          post :create, event: e.attributes
          expect(response.status).to eq(200)
        end
      end

      context "Edit action" do
        it "responds status 200 if current_user is owner of event" do
          e = create(:event)
          user.products << e
          get :edit, id: e.id
          expect(response.status).to eq(200)
        end
        it "response status 403 if current_user have no permissions" do
          e = create(:event)
          get :edit, id: e.id
          expect(response.status).to eq(403)
        end
      end

      context "Update action" do
        it "responds status 302 if valid data" do
          e = create(:event)
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki", tags: "Sport")
          e.reload
          expect(response.status).to eq(302)
        end
        it "response status 200 if invalid data" do
          e = create(:event)
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: nil, tags: "Sport")
          e.reload
          expect(response.status).to eq(200)
        end
        it "responds status 403 if current_user have no permissions" do
          e = create(:event)
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki", tags: "Sport")
          e.reload
          expect(response.status).to eq(403)
        end
      end

      context "Destroy action" do
        it "responds status 302 if user have permissions" do
          e = create(:event)
          user.products << e
          delete :destroy, id: e.id
          expect(response.status).to eq(302)
        end
        it "responds status 403 if user have no permissions" do
          e = create(:event)
          delete :destroy, id: e.id
          expect(response.status).to eq(403)
        end
      end

      context "Join action" do
        it "responds 302 if user wanna join" do
          e = create(:event)
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :join, id: e.id
          expect(response.status).to eq(302)
        end
        it "responds 302 if user already joined" do
          e = create(:event)
          user.events << e
          get :join, id: e.id
          expect(response.status).to eq(302)
        end
      end

      context "Unfollow action" do
        it "responds 302 if user wanna unfollow" do
          e = create(:event)
          user.events << e
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :unfollow, id: e.id
          expect(response.status).to eq(302)
        end
        it "responds 302 if user not joined yet" do
          e = create(:event)
          get :unfollow, id: e.id
          expect(response.status).to eq(302)
        end 
      end
    end
    
    context "if user NOT SIGNED" do
      it "Index action responds 200" do
        get :index
        expect(response.status).to eq(200)
      end
      it "New action responds 302" do
        get :new
        expect(response.status).to eq(302)
      end
      it "Create action responds 302" do
        e = build(:event)
        post :create, event: e.attributes
        expect(response.status).to eq(302)
      end
      it "Show action responds 200" do
        e = create(:event)
        get :show, id: e.id
        expect(response.status).to eq(200)
      end
      it "Update action responds 302" do
        e = create(:event)
        put :update, id: e.id, event: attributes_for(:event, name: "Pryatki")
        e.reload
        expect(response.status).to eq(302)
      end
      it "Destroy action responds 302" do
        e = create(:event)
        delete :destroy, id: e.id
        expect(response.status).to eq(302)
      end
      it "Join action responds 302" do
        e = create(:event)
        get :join, id: e.id
        expect(response.status).to eq(302)
      end
      it "Unfollow action responds 302" do
        e = create(:event)
        get :unfollow, id: e.id
        expect(response.status).to eq(302)
      end
    end
  end

  describe "template rendering" do
    context "if user SIGNED" do
      let(:user) {u = create(:user)}
      before {sign_in user}
      
      it "New action should render new template" do
        get :new
        expect(response).to render_template :new
      end
      
      context "Create action" do
        it "for valid event should redirect_to event's page" do
          e = build(:event)
          post :create, event: e.attributes
          expect(response).to redirect_to assigns(:event)
        end
        it "for invalid event should render new template" do
          e = build(:_event)
          post :create, event: e.attributes
          expect(response).to render_template :new
        end
      end

      context "Edit action" do
        it "render edit page if current_user is owner of event" do
          e = create(:event)
          user.products << e
          get :edit, id: e.id
          expect(response).to render_template :edit
        end
        it "render 403 page if current_user have no permissions" do
          e = create(:event)
          get :edit, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context "Update action" do
        it "redirect to even't page if valid data" do
          e = create(:event)
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki", tags: "Sport")
          e.reload
          expect(response).to redirect_to event_path(e)
        end
        it "render edit page if invalid data" do
          e = create(:event)
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: nil, tags: "Sport")
          e.reload
          expect(response).to render_template :edit
        end
        it "render 403 page if current_user have no permissions" do
          e = create(:event)
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki", tags: "Sport")
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context "Destroy action" do
        it "redirect to user's page if user have permissions" do
          e = create(:event)
          user.products << e
          delete :destroy, id: e.id
          expect(response).to redirect_to user_path(user)
        end
        it "render 403 page if user have no permissions" do
          e = create(:event)
          delete :destroy, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context "Join action" do
        it "redirect_to user's page if user wanna join" do
          e = create(:event)
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :join, id: e.id
          expect(response).to redirect_to :back
        end
        it "redirect_to back if user already joined" do
          e = create(:event)
          user.events << e
          get :join, id: e.id
          expect(response).to redirect_to user_path(user)
        end
      end

      context "Unfollow action" do
        it "redirect to back if user wanna unfollow" do
          e = create(:event)
          user.events << e
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :unfollow, id: e.id
          expect(response).to redirect_to :back
        end
        it "redirect to user's page if user not joined yet" do
          e = create(:event)
          get :unfollow, id: e.id
          expect(response).to redirect_to user_path(user)
        end 
      end
    end
    
    context "if user NOT SIGNED" do
      it "Index action render index template" do
        get :index
        expect(response).to render_template :index
      end
      it "New action redirect to sign in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
      it "Create action redirect to sign in page" do
        e = build(:event)
        post :create, event: e.attributes
        expect(response).to redirect_to new_user_session_path
      end
      it "Show action render event's page" do
        e = create(:event)
        get :show, id: e.id
        expect(response).to render_template :show
      end
      it "Update action redirect_to to sign in page" do
        e = create(:event)
        put :update, id: e.id, event: attributes_for(:event, name: "Pryatki")
        e.reload
        expect(response).to redirect_to new_user_session_path
      end
      it "Destroy action redirect_to to sign in page" do
        e = create(:event)
        delete :destroy, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
      it "Join action redirect_to to sign in page" do
        e = create(:event)
        get :join, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
      it "Unfollow action redirect_to to sign in page" do
        e = create(:event)
        get :unfollow, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "Logic" do
    context "for SIGNED users" do
      let(:user) {u = create(:user)}
      before {sign_in user}
      
      context "Create action" do
        it "should save new event if valid" do
          e = build(:event)
          expect{post :create, event: e.attributes}.to change(Event,:count).by(1)
        end
        it "shouldn't save any evens if not valid" do
          e = build(:_event)
          expect{post :create, event: e.attributes}.to change(Event,:count).by(0)
        end
        it "should add new event to user's products" do
          e = build(:event)
          expect{post :create, event: e.attributes}.to change(user.products,:count).by(1)
        end
      end

      context "Update action" do
        context "if user have permissions" do
          it "with valid data should update event" do
            e = create(:event)
            user.products << e
            put :update, id: e.id, event: attributes_for(:event, name: "newname", tags: "Sport")
            e.reload
            expect(Event.last.name).to eq("newname")
          end
          it "with not valid data shouldn't update event" do
            e = create(:event)
            user.products << e
            put :update, id: e.id, event: attributes_for(:event, name: nil, tags: "Sport")
            e.reload
            expect(Event.last.name).to eq("valid_event")
          end
        end
        context "if user have no permissions" do
          it "with valid data shouldn't update event" do
            e = create(:event)
            put :update, id: e.id, event: attributes_for(:event, name: "Newname", tags: "Sport")
            e.reload
            expect(Event.last.name).to eq("valid_event")
          end
          it "with not valid data shouldn't update event" do
            e = create(:event)
            put :update, id: e.id, event: attributes_for(:event, name: nil, tags: "Sport")
            e.reload
            expect(Event.last.name).to eq("valid_event")
          end
        end
      end

      context "destroy" do
        it "should destroy event if user have permissions" do
          e = create(:event)
          user.products << e
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(-1)
        end
        it "shouldn't destroy event if user have no permissions" do
          e = create(:event)
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
        end
      end

      context "Join action" do
        it "shouldn't add duplicate events to user's events" do
          e = create(:event)
          user.events << e
          get :join, id: e.id
          expect(user.events.count).to eq(1)
        end
        it "should add event to user's events" do
          e = create(:event)
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :join, id: e.id
          expect(user.events.count).to eq(1)
        end
      end
      context "unfollow action" do
        it "shouldn't delete any events if user not joined yet" do
          e1 = create(:event)
          e2 = create(:event)
          e3 = create(:event)
          user.events << [e1, e2]
          expect{get :unfollow, id: e3.id}.to change(user.events,:count).by(0)
        end
        it "should delete user event if user unfollowed" do
          e = create(:event)
          user.events << e
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          expect{get :unfollow, id: e.id}.to change(user.events,:count).by(-1)
        end
      end
    end

    context "for not SIGNED users" do
      it "Update action shouldn't update event" do
        e = create(:event)
        put :update, id: e.id, event: attributes_for(:event, name: nil, tags: "Sport")
        e.reload
        expect(Event.last.name).to eq("valid_event")
      end
      it "destroy action shouldn't destroy any events" do
        e = create(:event)
        expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
      end
      it "Join action shouldn't add any events if current_user=nil" do
        e = create(:event)
        u = create(:user)
        expect{get :join, id: e.id}.to change(u.events,:count).by(0)
      end
      it "Unfollow action shouldn't delete any events if current_user=nil" do
        e = create(:event)
        u = create(:user)
        expect{get :unfollow, id: e.id}.to change(u.events,:count).by(0)
      end
    end
  end

  describe "permited attributes" do
    let(:user) {u = create(:user)}
    before {sign_in user}
    let(:event) {e = create(:event)}
    it "should update event params" do
      t = create(:tag)
      e1 = create(:filled_event)
      e2 = create(:event)
      e1.tags << t
      user.products << e2
      put :update, id: e2.id, event: attributes_for(
        :event,
        name:         "birthday",
        date:         "10 Dec 2030",
        time:         "21:34",
        description:  "Description is here",
        gender:       "female",
        agemin:       '20',
        agemax:       '20',
        number:       '20',
        location:     "Suharevskaya str",
        latitude:     '0.0',
        longitude:    '0.0',
        tags:         "Sport"
        )
      e2.reload
      expect(Event.last.name).to eq(e1.name)
      expect(Event.last.date).to eq(e1.date)
      expect(Event.last.time).to eq(e1.time)
      expect(Event.last.description).to eq(e1.description)
      expect(Event.last.gender).to eq(e1.gender)
      expect(Event.last.agemin).to eq(e1.agemin)
      expect(Event.last.agemax).to eq(e1.agemax)
      expect(Event.last.number).to eq(e1.number)
      expect(Event.last.location).to eq(e1.location)
      expect(Event.last.latitude).to eq(e1.latitude)
      expect(Event.last.longitude).to eq(e1.longitude)
      expect(Event.last.tags).to eq(e1.tags)
    end
  end
end