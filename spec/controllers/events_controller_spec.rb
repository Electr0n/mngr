require 'rails_helper'

describe EventsController do
	
	describe "index action" do
		
		it "renders index view" do
			get :index
			expect(response).to be_success
		end

	end

	describe "show action" do

		it "renders show template if event is found" do
			e = create(:event)
			get :show, { id: e.id }
      		expect(response).to be_success
		end

	end

	describe "action create" do
		
		it "" do
			e = create(:event)
			post :create
			expect(e.errors.empty?).to eq("true")
      	end

	end

end