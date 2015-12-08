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
		it "should save" do
			e = create(:event)
			expect(e.save).to be true
      	end
      	it "sohuld render new if not valid event" do
      		e = build(:event, name: "ab")
      		post :create, event: e.attributes
      		expect(e.valid?).to be false and
      		 expect(response).to render_template(:new)		
      	end
	end

	describe "action NEW" do
		it "should render new" do
			get :new
			expect(response).to render_template(:new)
		end
	end

	#describe "action DESTROY" do
	#	it "should render index page after seccess" do
	#		e = create(:event)
	#		delete :destroy, id: e.id
	#		expect(response).to redirect_to(events_path)
	#	end
	#end

end