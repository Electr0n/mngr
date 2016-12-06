require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe "Action responses" do
    context "if user SIGNED" do
      let(:user)            {create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      before {
        user.roles << role_user
        sign_in user
      }
      
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
        let(:e) {create(:event)}
        it "responds status 200 if USER is owner of event" do
          user.products << e
          get :edit, id: e.id
          expect(response.status).to eq(200)
        end
        it "response status 403 if USER have is not owner" do
          get :edit, id: e.id
          expect(response.status).to eq(403)
        end
        it "response status 200 if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          get :edit, id: e.id
          expect(response.status).to eq(200)
        end
        it "response status 200 if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          get :edit, id: e.id
          expect(response.status).to eq(200)
        end
        it "response status 200 if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          get :edit, id: e.id
          expect(response.status).to eq(200)
        end
      end

      context "Update action" do
        let(:e) {create(:event)}
        it "responds status 302 if USER is owner" do
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
          e.reload
          expect(response.status).to eq(302)
        end
        it "responds status 302 if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
          e.reload
          expect(response.status).to eq(302)
        end
        it "responds status 302 if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
          e.reload
          expect(response.status).to eq(302)
        end
        it "responds status 302 if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
          e.reload
          expect(response.status).to eq(302)
        end
        it "response status 200 if invalid data" do
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: nil)
          e.reload
          expect(response.status).to eq(200)
        end
        it "responds status 403 if USER is not owner" do
          put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
          e.reload
          expect(response.status).to eq(403)
        end
      end

      context "Destroy action" do
        let(:e) {create(:event)}
        it "responds status 403 if USER is owner" do
          user.products << e
          delete :destroy, id: e.id
          expect(response.status).to eq(403)
        end
        it "responds status 403 if USER is not owner" do
          delete :destroy, id: e.id
          expect(response.status).to eq(403)
        end
        it "responds status 200 if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          delete :destroy, id: e.id
          expect(response.status).to eq(200)
        end
        it "responds status 403 if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          delete :destroy, id: e.id
          expect(response.status).to eq(403)
        end
        it "responds status 403 if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          delete :destroy, id: e.id
          expect(response.status).to eq(403)
        end
      end

      context "del_request" do
        let(:e) {create(:event)}
        it "responds status 200 if USER is owner" do
          user.products << e
          get :del_request, id: e.id
          e.reload
          expect(response.status).to eq(200)
        end
        it "responds status 403 if USER is not owner" do
          get :del_request, id: e.id
          e.reload
          expect(response.status).to eq(403)
        end
        it "responds status 200 if USER is SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          get :del_request, id: e.id
          e.reload
          expect(response.status).to eq(200)
        end
        it "responds status 200 if USER is ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          get :del_request, id: e.id
          e.reload
          expect(response.status).to eq(200)
        end
        it "responds status 200 if USER is MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          get :del_request, id: e.id
          e.reload
          expect(response.status).to eq(200)
        end
      end

      context "Join action" do
        let(:e) {create(:event)}
        it "responds 302 if user wanna join" do
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :join, id: e.id
          expect(response.status).to eq(302)
        end
        it "responds 302 if user already joined" do
          user.events << e
          get :join, id: e.id
          expect(response.status).to eq(302)
        end
      end

      context "Unfollow action" do
        let(:e) {create(:event)}
        it "responds 302 if user wanna unfollow" do
          user.events << e
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :unfollow, id: e.id
          expect(response.status).to eq(302)
        end
        it "responds 302 if user not joined yet" do
          get :unfollow, id: e.id
          expect(response.status).to eq(302)
        end 
      end
    end
    
    context "if user NOT SIGNED" do
      let(:e) {create(:event)}
      it "Index action responds 200" do
        get :index
        expect(response.status).to eq(200)
      end
      it "New action responds 302" do
        get :new
        expect(response.status).to eq(302)
      end
      it "Create action responds 302" do
        _e = build(:event)
        post :create, event: _e.attributes
        expect(response.status).to eq(302)
      end
      it "Show action responds 200" do
        get :show, id: e.id
        expect(response.status).to eq(200)
      end
      it "Update action responds 302" do
        put :update, id: e.id, event: attributes_for(:event, name: "Pryatki")
        e.reload
        expect(response.status).to eq(302)
      end
      it "Destroy action responds 302" do
        delete :destroy, id: e.id
        expect(response.status).to eq(302)
      end
      it "Join action responds 302" do
        get :join, id: e.id
        expect(response.status).to eq(302)
      end
      it "Unfollow action responds 302" do
        get :unfollow, id: e.id
        expect(response.status).to eq(302)
      end
    end
  end

  describe "template rendering" do
    context "if user SIGNED" do
      let(:user) {u = create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      before {
        user.roles << role_user
        sign_in user
      }

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
        let(:e) {create(:event)}
        it "render edit page if USER is owner of event" do
          user.products << e
          get :edit, id: e.id
          expect(response).to render_template :edit
        end
        it "render 403 page if USER is not owner" do
          get :edit, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "render edit page if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          get :edit, id: e.id
          expect(response).to render_template :edit
        end
        it "render edit page if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          get :edit, id: e.id
          expect(response).to render_template :edit
        end
        it "render edit page if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          get :edit, id: e.id
          expect(response).to render_template :edit
        end
      end

      context "Update action" do
        let(:e) {create(:event)}
        context "for valid data" do
          it "redirect to event's page if USER is owner" do
            user.products << e
            put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
            e.reload
            expect(response).to redirect_to event_path(e)
          end
          it "render 403 page if USER is not owner" do
            put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
            e.reload
            expect(response).to render_template file: "#{Rails.root}/public/403.html"
          end
          it "redirect_to event's page if SUPERADMIN" do
            user.roles.delete(role_user)
            user.roles << role_superadmin
            put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
            e.reload
            expect(response).to redirect_to event_path(e)
          end
          it "redirect_to event's page if ADMIN" do
            user.roles.delete(role_user)
            user.roles << role_admin
            put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
            e.reload
            expect(response).to redirect_to event_path(e)
          end
          it "redirect_to event's page if MODERATOR" do
            user.roles.delete(role_user)
            user.roles << role_moderator
            put :update, id: e.id, event: attributes_for(:event, name: "Prytki")
            e.reload
            expect(response).to redirect_to event_path(e)
          end
        end
        it "render edit page if invalid data" do
          user.products << e
          put :update, id: e.id, event: attributes_for(:event, name: nil)
          e.reload
          expect(response).to render_template :edit
        end
      end

      context "Destroy action" do
        let(:e) {create(:event)}
        it "render 403 page if USER owner" do
          user.products << e
          delete :destroy, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "redirect_to user's page for SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          delete :destroy, id: e.id
          expect(response).to render_template :index
        end
        it "render 403 page if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          delete :destroy, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "render 403 page if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          delete :destroy, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "render 403 page if user have no permissions" do
          delete :destroy, id: e.id
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context "del_request" do
        let(:e) {create(:event)}
        it "render deleted template if USER is owner" do
          user.products << e
          get :del_request, id: e.id
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/system/events/deleted.html"
        end
        it "render 403 page if USER is not owner" do
          get :del_request, id: e.id
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it "render deleted template if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          get :del_request, id: e.id
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/system/events/deleted.html"
        end
        it "render deleted template if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          get :del_request, id: e.id
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/system/events/deleted.html"
        end
        it "render deleted template if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          get :del_request, id: e.id
          e.reload
          expect(response).to render_template file: "#{Rails.root}/public/system/events/deleted.html"
        end
      end

      context "Join action" do
        let(:e) {create(:event)}
        it "redirect_to user's page if user wanna join" do
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :join, id: e.id
          expect(response).to redirect_to :back
        end
        it "redirect_to back if user already joined" do
          user.events << e
          get :join, id: e.id
          expect(response).to redirect_to user_path(user)
        end
      end

      context "Unfollow action" do
        let(:e) {create(:event)}
        it "redirect to back if user wanna unfollow" do
          user.events << e
          @request.env['HTTP_REFERER'] = 'http://localhost:3000'
          get :unfollow, id: e.id
          expect(response).to redirect_to :back
        end
        it "redirect to user's page if user not joined yet" do
          get :unfollow, id: e.id
          expect(response).to redirect_to user_path(user)
        end 
      end
    end
    
    context "if user NOT SIGNED" do
      let(:e) {create(:event)}
      it "Index action render index template" do
        get :index
        expect(response).to render_template :index
      end
      it "New action redirect to sign in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
      it "Create action redirect to sign in page" do
        _e = build(:event)
        post :create, event: _e.attributes
        expect(response).to redirect_to new_user_session_path
      end
      it "Show action render event's page" do
        get :show, id: e.id
        expect(response).to render_template :show
      end
      it "Update action redirect_to to sign in page" do
        put :update, id: e.id, event: attributes_for(:event, name: "Pryatki")
        e.reload
        expect(response).to redirect_to new_user_session_path
      end
      it "Destroy action redirect_to to sign in page" do
        delete :destroy, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
      it "Join action redirect_to to sign in page" do
        get :join, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
      it "Unfollow action redirect_to to sign in page" do
        get :unfollow, id: e.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "Logic" do
    context "for SIGNED users" do
      let(:user) {u = create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      before {
        user.roles << role_user
        sign_in user
      }

      context "Create action" do
        it "should save new event if valid" do
          e = build(:event)
          expect{post :create, event: e.attributes}.to change(Event,:count).by(1)
        end
        it "shouldn't save any event if not valid" do
          e = build(:_event)
          expect{post :create, event: e.attributes}.to change(Event,:count).by(0)
        end
        it "should add new event to user's products" do
          e = build(:event)
          expect{post :create, event: e.attributes}.to change(user.products,:count).by(1)
        end
      end

      context "Update action" do
        let(:e) {create(:event)}
        context "if USER is owner" do
          before {user.products << e}
          it "with valid data should update event" do
            put :update, id: e.id, event: attributes_for(:event, name: "newname")
            e.reload
            expect(Event.last.name).to eq("newname")
          end
          it "should update event's tags with uniq data" do
            create(:sport_tag)
            create(:music_tag)
            put :update, id: e.id, event: attributes_for(:event, name: "newname", tags: ["Sport", "", "Music", "Music"])
            e.reload
            expect(Event.last.tags.count).to eq(2)
          end
          it "with not valid data shouldn't update event" do
            put :update, id: e.id, event: attributes_for(:event, name: nil)
            e.reload
            expect(Event.last.name).to eq("valid_event")
          end
        end
        it "if USER is not owner" do
          e = create(:event)
          put :update, id: e.id, event: attributes_for(:event, name: "Newname")
          e.reload
          expect(Event.last.name).to eq("valid_event")
        end
        it "should update any event if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          put :update, id: e.id, event: attributes_for(:event, name: "newname")
            e.reload
            expect(Event.last.name).to eq("newname")
        end
        it "should update any event if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          put :update, id: e.id, event: attributes_for(:event, name: "newname")
            e.reload
            expect(Event.last.name).to eq("newname")
        end
        it "should update any event if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          put :update, id: e.id, event: attributes_for(:event, name: "newname")
            e.reload
            expect(Event.last.name).to eq("newname")
        end
      end

      context "destroy" do
        it "shouldn't destroy event if USER is owner" do
          e = create(:event)
          user.products << e
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
        end
        it "shouldn't destroy event if USER is not owner" do
          e = create(:event)
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
        end
        it "should destroy any event if SUPERADMIN" do
          e = create(:event)
          user.roles.delete(role_user)
          user.roles << role_superadmin
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(-1)
        end
        it "should destroy any event if ADMIN" do
          e = create(:event)
          user.roles.delete(role_user)
          user.roles << role_admin
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
        end
        it "should destroy any event if MODERATOR" do
          e = create(:event)
          user.roles.delete(role_user)
          user.roles << role_moderator
          expect{delete :destroy, id: e.id}.to change(Event,:count).by(0)
        end
      end

      context "del_request" do
        let(:e) {create(:event)}
        it "should set del_flag by true if USER is owner" do
          user.products << e
          get :del_request, id: e.id
          e.reload
          expect(e.del_flag).to eq(true)
        end
        it "shouldn't change del_flag if USER is not owner " do
          get :del_request, id: e.id
          e.reload
          expect(e.del_flag).to eq(false)
        end
        it "should ser del_flag be true if SUPERADMIN" do
          user.roles.delete(role_user)
          user.roles << role_superadmin
          get :del_request, id: e.id
          e.reload
          expect(e.del_flag).to eq(true)
        end
        it "should ser del_flag be true if ADMIN" do
          user.roles.delete(role_user)
          user.roles << role_admin
          get :del_request, id: e.id
          e.reload
          expect(e.del_flag).to eq(true)
        end
        it "should ser del_flag be true if MODERATOR" do
          user.roles.delete(role_user)
          user.roles << role_moderator
          get :del_request, id: e.id
          e.reload
          expect(e.del_flag).to eq(true)
        end
      end

      context "Join action" do
        let(:e) {create(:event)}
        it "shouldn't add duplicate events to user's events" do
          user.events << e
          get :join, id: e.id
          expect(user.events.count).to eq(1)
        end
        it "should add event to user's events" do
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
        put :update, id: e.id, event: attributes_for(:event, name: nil, tags: ["Sport"])
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

  describe 'search' do

    let(:party_event)   {create(:party_event)}
    let(:concert_event) {create(:concert_event)}
    let(:box_event)     {create(:box_event)}
    let(:dating_event)  {create(:dating_event)}
    let(:football_event){create(:football_event)}
    let(:beer_event)    {create(:beer_event)}
    let(:sport_tag)     {create(:sport_tag)}
    let(:dating_tag)    {create(:dating_tag)}
    let(:music_tag)     {create(:music_tag)}
    let(:party_tag)     {create(:party_tag)}
    let(:drink_tag)     {create(:drink_tag)}
    before {
        party_event.tags    << [party_tag, drink_tag]
        concert_event.tags  << [music_tag]
        box_event.tags      << [sport_tag]
        dating_event.tags   << [dating_tag]
        football_event.tags << [sport_tag, drink_tag]
        beer_event.tags     << [drink_tag]
      }

    it "it should find all events if empty form" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(Event.all.count)
    end
    it "should return 2 events by name" do
      data = {
        "name_cont"=>"ee",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(2)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([beer_event, dating_event].sort)
    end
    it "should return 4 events after 9/12/2018" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"2018",
        "date_gteq(2i)"=>"12",
        "date_gteq(3i)"=>"9",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(4)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([beer_event, dating_event, football_event, box_event].sort)
    end
    it "should return events where agemax > 60" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"60",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(4)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([beer_event, party_event, box_event, football_event].sort)
    end
    it "should return events where agemin < 17 " do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"17",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(3)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([football_event, concert_event, party_event].sort)
    end
    it "should return events where location containt 'str'" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"str",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(4)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([football_event, concert_event, party_event, beer_event].sort)
    end
    it "should return events gender male" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"female",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in_all"=>[""]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(5)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([football_event, beer_event, concert_event, dating_event, box_event].sort)
    end
    it "should return events where tags in selected array" do
      data = {
        "name_cont"=>"",
        "date_gteq(1i)"=>"",
        "date_gteq(2i)"=>"",
        "date_gteq(3i)"=>"",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"",
        "agemin_lteq"=>"",
        "location_cont"=>"",
        "tags_name_in"=>["sport", "drink"]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(4)
      expect(Event.ransack(data).result(distinct: true).sort).to eq([football_event, beer_event, party_event, box_event].sort)
    end
    it "should return events where tags in selected array" do
      data = {
        "name_cont"=>"ee",
        "date_gteq(1i)"=>"2016",
        "date_gteq(2i)"=>"10",
        "date_gteq(3i)"=>"10",
        "gender_not_eq"=>"",
        "agemax_gteq"=>"18",
        "agemin_lteq"=>"80",
        "location_cont"=>"str",
        "tags_name_in"=>["sport", "drink"]}
      expect(Event.ransack(data).result(distinct: true).count).to eq(1)
      expect(Event.ransack(data).result(distinct: true)).to eq([beer_event])
    end
  end

  describe 'Params init' do
    let(:user) {create(:user)}
    let(:event) {create(:event)}
    let(:role_user) {create(:role_user)}
    before {
      user.roles << role_user
      user.products << event
      sign_in user
    }
    it "should update event with default values if fields(agemin, agemax, number) are blank" do
      put :update, id: event.id, event: attributes_for(:event, name: "newname", agemin: '', agemax: '', number: '', tags: ["Sport"])
      event.reload
      expect(Event.last.agemax).to eq(150)
      expect(Event.last.agemin).to eq(0)
      expect(Event.last.number).to eq(194673)
    end
    it "should save event with default values if fields(agemin, agemax, number) are blank" do
      e = build(:event)
      e.agemin = ''
      e.agemax = ''
      e.number = ''
      post :create, event: e.attributes
      expect(Event.last.agemax).to eq(150)
      expect(Event.last.agemin).to eq(0)
      expect(Event.last.number).to eq(194673)
    end
  end

  describe "permited attributes" do
    let(:user) {create(:user)}
    let(:role_user) {create(:role_user)}
    before {
      user.roles << role_user
      sign_in user
    }
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
        del_flag:     'true', 
        tags:         ["Sport"]
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
      expect(Event.last.del_flag).to eq(e1.del_flag)
      expect(Event.last.tags).to eq(e1.tags)
    end
    it "should update photo" do
      e = create(:event)
      e.photo = File.open("#{Rails.root}/public/favicon.ico")
      expect(e.photo_file_name).to eq("favicon.ico")
    end
  end
end