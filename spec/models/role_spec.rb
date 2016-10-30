require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'association Role-User' do
    before(:each) do
      @u1 = create(:user)
      @u2 = create(:kolya_user)
      @r1 = create(:role_admin)
      @r2 = create(:role_moderator)
    end
    it 'role can have many users' do
      @r1.users << [@u1, @u2]
      expect(@r1.users.count).to eq(2)
    end
    it 'roles can have same user' do
      @r1.users << @u1
      @r2.users << @u1
      expect(@r1.users.count).to eq(1)
      expect(@r2.users.count).to eq(1)
    end
  end
end
