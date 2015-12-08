require 'rails_helper'

describe UsersController do
	
	let(:user) { u = create(:user) }

	before { sign_in user }

	describe "action INDEX" do
		it "should render index" do
			get :index
			expect(response).to render_template(:index)
		end
	end

	describe "action NEW" do
		it "should render new" do
			get :new
			expect(response).to render_template(:new)
		end
	end

	describe "action CREATE" do
		it "should save user and render user's page" do
			u = build(:user)
			expect(u.save).to eq(true) and
			 expect(get :show, {id: u.id }).to render_template(:show)
		end
		it "should render new template till user not valid" do
			u = build(:user, email: "notvalid")
			post :create, user: u.attributes
			expect(u.valid?).to be false and
			 expect(response).to render_template(:new)
		end
	end

	describe "action SHOW" do
		it "should redirect to user's page" do
			u = create(:user)
			get :show, { id: u.id }
			expect(response).to render_template(:show)
		end
		it "should render 404 if user doesn't exist" do
			u = build(:user, id: "notvalid")
			get :show, { id: u.id }
			expect(response.status).to eq(404)
		end
	end

	describe "action DESTROY" do
		it "should delete user" do
			u = create(:user)
			delete :destroy, { id: u.id }
			expect(response).to render_template(:index)
		end
	end

end