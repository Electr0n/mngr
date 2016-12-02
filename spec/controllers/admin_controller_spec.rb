require 'rails_helper'

RSpec.describe AdminController, type: :controller do

  describe 'response status' do

    context 'for signed:' do
      let(:user)            {create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      before {
        user.roles << role_user
        sign_in user
      }

      context 'users action' do
        it 'should be 403 if USER' do
          user.roles << role_user
          get :users
          expect(response.status).to eq(403)
        end
        it 'should be 403 if MODERATOR' do
          user.roles << role_moderator
          get :users
          expect(response.status).to eq(403)
        end
        it 'should be 200 if ADMIN' do
          user.roles << role_admin
          get :users
          expect(response.status).to eq(200)
        end
        it 'should be 200 if SUPERADMIN' do
          user.roles << role_superadmin
          get :users
          expect(response.status).to eq(200)
        end
      end

    end

    context 'for unsigned:' do

      it 'users action should be 403' do
        get :users
        expect(response.status).to eq(403)
      end

    end

  end

  describe 'template rendering' do

    context 'for signed:' do
      let(:user)            {create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      before {
        user.roles << role_user
        sign_in user
      }

      context 'users action' do
        it 'should render forbidden page if user' do
          user.roles << role_user
          get :users
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it 'should render forbidden page if MODERATOR' do
          user.roles << role_moderator
          get :users
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
        it 'should render users page if ADMIN' do
          user.roles << role_admin
          get :users
          expect(response).to render_template :users
        end
        it 'should render users page if SUPERADMIN' do
          user.roles << role_superadmin
          get :users
          expect(response).to render_template :users
        end
      end
    end

    context 'for unsigned' do
      it 'Users action sohuld redirect to sign_in template' do
        get :users
        expect(response).to render_template file: "#{Rails.root}/public/403.html"
      end
    end

  end

end
