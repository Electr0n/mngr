require 'rails_helper'

describe EventsController do
	
	describe "action INDEX" do
		it "renders index view" do
			get :index
			expect(response).to render_template(:index)
		end
	end

	describe "action SHOW" do
		it "renders show template if event is found" do
			e = create(:event)
			get :show, { id: e.id }
      		expect(response).to render_template(:show)
		end
	end

	describe "action CREATE" do
		it "should save event, push it to current user and render event's page" do
			u = create(:user)
			sign_in u
			e = build(:event)
			post :create, event: e.attributes
			expect(e.save).to be true and
			 expect(u.events.count).to eq(1) and
			  expect(get :show, {id: e.id}).to render_template(:show)
      	end
      	it "sohuld render new if not valid event" do
      		e = build(:event, name: "ab")
      		post :create, event: e.attributes
      		expect(e.valid?).to be false and
      		 expect(response).to render_template(:new)		
      	end
	end

	describe "action UPDATE" do
		it "should update and redirect to event's page" do
			e = create(:event)
			put :update, { id: e.id, event: attributes_for(:event, name: "newname")}
			e.reload
			expect(e.name).to eq("newname") and
			 expect(response).to redirect_to event_path(e)
		end
		it "should render edit if not valid attributes for update" do
			e = build(:event)
			e.save
			put :update, { id: e.id, event: attributes_for(:event, name: "ne")}
			e.reload
			expect(e.name).not_to eq("ne")
			put :update, { id: e.id, event: attributes_for(:event, name: "ne")}
			expect(response).to render_template(:edit)
		end
	end

	describe "action NEW" do
		it "should render new" do
			get :new
			expect(response).to render_template(:new)
		end
	end

	describe "action DESTROY" do
		it "should render index page after seccess" do
			u = create(:user)
			sign_in u
			e = create(:event)
			delete :destroy, { id: e.id }
			expect(response).to redirect_to(user_path(u))
		end
	end

	describe "action JOIN" do
		it "should add event to user's event list and redirect back" do
			u = create(:user)
			sign_in u
			e = create(:event)
			@request.env['HTTP_REFERER'] = 'http://test.com/users/index'
			get :join, {id: e.id }
			expect(response).to redirect_to(:back)
		end
		it "should render current user's page couse event is already iclude in evets page" do
			u = create(:user)
			sign_in u
			e = create(:event)
			u.events << e
			@request.env['HTTP_REFERER'] = 'http://test.com/users/index'
			get :join, {id: e.id }
			expect(response).to redirect_to(user_path(u))
		end
	end

	describe "action UNFOLLOW" do
		it "should delete event from user's list and redirect back" do
			u = create(:user)
			sign_in u
			e = create(:event)
			u.events << e
			@request.env['HTTP_REFERER'] = 'http://test.com/users/index'
			get :unfollow, {id: e.id }
			expect(response).to redirect_to(:back)
		end
		it "should render current user's page couse user's list already not inlcude this event" do
			u = create(:user)
			sign_in u
			e = create(:event)
			@request.env['HTTP_REFERER'] = 'http://test.com/users/index'
			get :unfollow, {id: e.id }
			expect(response).to redirect_to(user_path(u))
		end
	end

end