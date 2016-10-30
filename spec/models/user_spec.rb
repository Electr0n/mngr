require "rails_helper"

RSpec.describe User, type: :model do 

  describe "Associations" do
    describe 'Roles-Users' do
      it 'User should have many roles' do
        u = create(:user)
        r1 = create(:role_admin)
        r2 = create(:role_user)
        u.roles << [r1, r2]
        expect(u.roles.count).to eq(2)
      end
      it 'Users can have same role' do
        u1 = create(:user)
        u2 = create(:petya_user)
        r = create(:role_admin)
        u1.roles << r
        u2.roles << r
        expect(u1.roles.count).to eq(1)
        expect(u2.roles.count).to eq(1)
      end
    end

    describe "Events-Users" do
      it "User should have many events" do
        u = create(:user)
        e1 = create(:event)
        e2 = create(:event)
        u.events << [e1, e2]
        expect(u.events.count).to eq(2)
      end
      it "Several users can have same event" do
        u1 = create(:user)
        u2 = create(:user)
        e = create(:event)
        u1.events << e
        u2.events << e
        expect(u1.events.count).to eq(1)
        expect(u2.events.count).to eq(1)
      end
    end

    describe "Owner-Products" do
      it "User(as owner) should have many events (as products)" do
        u = create(:user)
        e1 = create(:event)
        e2 = create(:event)
        u.products << [e1, e2]
        expect(u.products.count).to eq(2)
      end
      it "Several users(as owners) can have same event (as product)" do
        u1 = create(:user)
        u2 = create(:user)
        e = create(:event)
        u1.products << e
        u2.products << e
        expect(u1.products.count).to eq(1)
        expect(u2.products.count).to eq(1)
      end
    end

    describe "Tags-Users" do
      it "User should have many tags" do
        u = create(:user)
        t1 = create(:tag)
        t2 = create(:tag)
        u.tags << [t1, t2]
        expect(u.tags.count).to eq(2)
      end
      it "Several users can have same event" do
        u1 = create(:user)
        u2 = create(:user)
        t = create(:tag)
        u1.tags << t
        u2.tags << t
        expect(u1.tags.count).to eq(1)
        expect(u2.tags.count).to eq(1)
      end
    end
  end

  describe "validations" do
    it "Shouldn't be valid without email" do
      u = create(:user)
      u.email = nil
      expect(u.valid?).to be false
    end
    it "Shouldn't be valid with wrong type of email" do
      u = create(:user)
      u.email = "hohohaha.com"
      expect(u.valid?).to be false
    end
    it "Shouldn't be valid with wrong type of email" do
      u = create(:user)
      u.email = "hohohaha@com"
      expect(u.valid?).to be false
    end
    it "Shouldn't be valid with duplicate email" do
      u1 = create(:user, email: "Hello@world.com")
      u2 = create(:user)
      u2.email = "Hello@world.com"
      expect(u2.valid?).to be false
    end
    it "Shouldn't be valid without password" do
      u = create(:user)
      u.password = ""
      expect(u.valid?).to be false
    end
  end

  describe "advansed methods" do
    let(:user) {u = create(:user)}
    it "should return full country name" do
      user.country = "BY"
      expect(user.country_).to eq("Belarus")
    end
    it "should return full city name" do
      user.country = "BY"
      user.city = "HM"
      expect(user.city_).to eq("Horad Minsk")
    end
  end

  describe "search" do
    let(:user) {u = create(:filled_user)}
    it "should find all users with <valid> in name" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('valid', '', '', '', '', '', '')
      expect(f.count).to eq(4)
    end
    it "should find all users with <kin> in surname" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('v', 'kin', '', '', '', '', '')
      expect(f.count).to eq(3)
    end
    it "should find all users users with <male> in gender" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('', '', 'male', '', '', '', '')
      expect(f.include?(u4)).to be false
      expect(f.count).to eq(3)
    end
    it "should find all users users with <1992> in year" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('', '', 'male', '1992', '', '', '')
      expect(f.count).to eq(2)
    end
    it "should find all users users with <december> in month" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('', '', '', '', '12', '', '')
      expect(f.count).to eq(4)
    end
    it "should find all users users with <BY> in country" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('valid', '', 'male', '1992', '', 'BY', '')
      expect(f.count).to eq(2)
    end
    it "should find all users users with <HM> in city" do
      u1 = create(:filled_user)
      u2 = create(:petya_user)
      u3 = create(:vasya_user)
      u4 = create(:kolya_user)
      u5 = create(:user)
      f = User.search('', '', 'female', '', '', '', 'HM')
      expect(f.count).to eq(1)
    end
  end

  describe "omniauth" do
    describe "vk" do
      auth_hash = OmniAuth::AuthHash.new({
        :provider => 'vkontakte',
        :uid => '1234',
        :info => {
          :email => "user@example.com"
        },
        extra: {
          raw_info: {
            :first_name => "Vasya",
            :last_name => "Pupkin"
          }
        }
      })
      it "should create new user" do
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "Shouldn't create duplicate user if already exist" do
        User.from_omniauth(auth_hash)
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "should create user with described fields" do
        u = User.from_omniauth(auth_hash)
        expect(u.name).to eq("Vasya")
        expect(u.surname).to eq('Pupkin')
        expect(u.email).to eq('1234@vkontakte.com')
        expect(u.uid).to eq('1234')
        expect(u.provider).to eq('vkontakte')
      end
    end

    describe "facebook" do
      auth_hash = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :email => 'joe@bloggs.com',
          :name => 'alibaba Bloggs'
        },
        extra: {
          raw_info: {
            first_name: 'alibaba',
            last_name: 'Bloggs'
          }
        }
      })
      it "should create new user with described fields" do
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "Shouldn't create duplicate user if already exist" do
        User.from_omniauth(auth_hash)
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "should create same user" do
        u = User.from_omniauth(auth_hash)
        expect(u.name).to eq("alibaba")
        expect(u.surname).to eq('Bloggs')
        expect(u.email).to eq('1234567@facebook.com')
        expect(u.uid).to eq('1234567')
        expect(u.provider).to eq('facebook')
      end
    end

    describe "twitter" do
      auth_hash = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => '12345',
        :info => {
          :email => 'joe@bloggs.com',
          :name => 'alibaba Bloggs'
        }
      })
      it "should create new user with described fields" do
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "Shouldn't create duplicate user if already exist" do
        User.from_omniauth(auth_hash)
        User.from_omniauth(auth_hash)
        expect(User.count).to eq(1)
      end
      it "should create same user" do
        u = User.from_omniauth(auth_hash)
        expect(u.name).to eq("alibaba")
        expect(u.surname).to eq('Bloggs')
        expect(u.email).to eq('12345@twitter.com')
        expect(u.uid).to eq('12345')
        expect(u.provider).to eq('twitter')
      end
    end
  end
end