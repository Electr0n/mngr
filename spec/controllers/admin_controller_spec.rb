require 'rails_helper'

RSpec.describe AdminController, type: :controller do

  describe 'Response/rendering:' do
    
    context 'for signed as' do

      let(:user)            {create(:user)}
      let(:role_user)       {create(:role_user)}
      let(:role_superadmin) {create(:role_superadmin)}
      let(:role_admin)      {create(:role_admin)}
      let(:role_moderator)  {create(:role_moderator)}
      let(:role_banned)     {create(:role_banned)}
      before {
        user.roles << role_user
        role_banned
        @request.env['HTTP_REFERER'] = 'http://localhost:3000'
        sign_in user
      }

      context 'as SUPERADMIN' do
        before { user.roles << role_superadmin }
        
        it 'index action should render index template(200)' do
          get :index
          expect(response.status).to eq(200)
          expect(response).to render_template :index
        end

        it 'users action should render users template(200)' do
          get :users
          expect(response.status).to eq(200)
          expect(response).to render_template :users
        end

        it 'events action should render events template(200)' do
          get :events
          expect(response.status).to eq(200)
          expect(response).to render_template :events
        end

        it 'ban action should redirect_to :back (302)' do
          u = create(:filled_user)
          get :ban, id: u.id
          expect(response.status).to eq(302)
          expect(response).to redirect_to :back
        end

        it 'unban action should redirect_to :back (302)' do
          u = create(:filled_user)
          u.roles << role_banned
          get :unban, id: u.id
          expect(response.status).to eq(302)
          expect(response).to redirect_to :back
        end
      end

      context 'as ADMIN' do
        before { user.roles << role_admin }
        
        it 'index action should render index template(200)' do
          get :index
          expect(response.status).to eq(200)
          expect(response).to render_template :index
        end

        it 'users action should render users template(200)' do
          get :users
          expect(response.status).to eq(200)
          expect(response).to render_template :users
        end

        it 'events action should render events template(200)' do
          get :events
          expect(response.status).to eq(200)
          expect(response).to render_template :events
        end

        it 'ban action should redirect_to :back (302)' do
          u = create(:filled_user)
          get :ban, id: u.id
          expect(response.status).to eq(302)
          expect(response).to redirect_to :back
        end

        it 'unban action should redirect_to :back (302)' do
          u = create(:filled_user)
          u.roles << role_banned
          get :unban, id: u.id
          expect(response.status).to eq(302)
          expect(response).to redirect_to :back
        end
      end

      context 'as MODERATOR' do
        before { user.roles << role_moderator }
        
        it 'index action should render access denied template(403)' do
          get :index
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'users action should render access denied template(403)' do
          get :users
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'events action should render access denied template(403)' do
          get :events
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'ban action should render access denied template(403)' do
          u = create(:filled_user)
          get :ban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'unban action should render access denied template(403)' do
          u = create(:filled_user)
          u.roles << role_banned
          get :unban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context 'as USER' do
        before { user.roles << role_user }
        
        it 'index action should render access denied template(403)' do
          get :index
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'users action should render access denied template(403)' do
          get :users
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'events action should render access denied template(403)' do
          get :events
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'ban action should render access denied template(403)' do
          u = create(:filled_user)
          get :ban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'unban action should render access denied template(403)' do
          u = create(:filled_user)
          u.roles << role_banned
          get :unban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

      context 'as BANNED' do
        before { user.roles << role_banned }
        
        it 'index action should render index template(403)' do
          get :index
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'users action should render access denied template(403)' do
          get :users
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'events action should render access denied template(403)' do
          get :events
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'ban action should render access denied template(403)' do
          u = create(:filled_user)
          get :ban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end

        it 'unban action should render access denied template(403)' do
          u = create(:filled_user)
          u.roles << role_banned
          get :unban, id: u.id
          expect(response.status).to eq(403)
          expect(response).to render_template file: "#{Rails.root}/public/403.html"
        end
      end

    end

    context 'for unsigned' do

      let(:role_banned) {create(:role_banned)}

      before { role_banned }

      it 'index action should redirect_to sign_in page (302)' do
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'users action should redirect_to sign_in page (302)' do
        get :users
        expect(response.status).to eq(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'events action should redirect_to sign_in page (302)' do
        get :events
        expect(response.status).to eq(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'ban action should redirect_to sign_in page (302)' do
        u = create(:filled_user)
        get :ban, id: u.id
        expect(response.status).to eq(302)
        expect(response).to redirect_to new_user_session_path
      end

      it 'unban action should redirect_to sign_in page (302)' do
        u = create(:filled_user)
        u.roles << role_banned
        get :unban, id: u.id
        expect(response.status).to eq(302)
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe 'logic:' do

    let(:user)            {create(:user)}
    let(:u)               {create(:filled_user)}
    let(:role_user)       {create(:role_user)}
    let(:role_superadmin) {create(:role_superadmin)}
    let(:role_admin)      {create(:role_admin)}
    let(:role_moderator)  {create(:role_moderator)}
    let(:role_banned)     {create(:role_banned)}
    before {
      user.roles << role_user
      role_banned
      @request.env['HTTP_REFERER'] = 'http://localhost:3000'
    }

    context 'signed as' do

      before { 
        sign_in user
        u
      }

      context 'SUPERADMIN' do

        before { user.roles << role_superadmin }

        it 'ban action should add banned role to user' do
          get :ban, id: u.id
          expect(u.banned?).to be true
        end

        it 'unban action should remove banned roles from user' do
          u.roles << role_banned
          get :unban, id: u.id
          expect(u.banned?).to be false
        end

      end

      context 'ADMIN' do

        before { user.roles << role_admin }

        it 'ban action should add banned role to user' do
          get :ban, id: u.id
          expect(u.banned?).to be true
        end

        it 'unban action should remove banned roles from user' do
          u.roles << role_banned
          get :unban, id: u.id
          expect(u.banned?).to be false
        end

      end
      
      context 'MODERATOR' do

        before { user.roles << role_moderator }

        it 'ban action should not ban any user' do
          get :ban, id: u.id
          expect(u.banned?).to be false
        end

        it 'unban action should not unban any user' do
          u.roles << role_banned
          get :unban, id: u.id
          expect(u.banned?).to be true
        end

      end
      
      context 'USER' do

        before { user.roles << role_user }

        it 'ban action should not ban any user' do
          get :ban, id: u.id
          expect(u.banned?).to be false
        end

        it 'unban action should not unban any user' do
          u.roles << role_banned
          get :unban, id: u.id
          expect(u.banned?).to be true
        end

      end
      
      context 'BANNED' do

        before { user.roles << role_banned }

        it 'ban action should not ban any user' do
          get :ban, id: u.id
          expect(u.banned?).to be false
        end

        it 'unban action should not unban any user' do
          u.roles << role_banned
          get :unban, id: u.id
          expect(u.banned?).to be true
        end

      end

    end

    context 'unsigned' do

      let(:u)               {create(:filled_user)}
      let(:role_banned)     {create(:role_banned)}
      
      before {
        role_banned
        @request.env['HTTP_REFERER'] = 'http://localhost:3000'
      }

      it 'ban action should not ban any user' do
        get :ban, id: u.id
        expect(u.banned?).to be false
      end

      it 'unban action should not unban any user' do
        u.roles << role_banned
        get :unban, id: u.id
        expect(u.banned?).to be true
      end

    end
  end

end
