require "rails_helper"

RSpec.describe User, type: :model do 

  describe "Associations" do
    let(:u1) {create(:user)}
    let(:u2) {create(:filled_user)}
    let(:e1) {create(:event)}
    let(:e2) {create(:filled_event)}
    let(:t1) {create(:tag_films)}
    let(:t2) {create(:tag)}
    let(:r1) {create(:role_user)}
    let(:r2) {create(:role_admin)}
    describe 'Roles-Users' do
      it 'User should have many roles' do
        u1.roles << [r1, r2]
        expect(u1.roles.count).to eq(2)
      end
      it 'Users can have same role' do
        u1.roles << r1
        u2.roles << r1
        expect(u1.roles.count).to eq(1)
        expect(u2.roles.count).to eq(1)
      end
    end

    describe "Events-Users" do
      it "User should have many events" do
        u1.events << [e1, e2]
        expect(u1.events.count).to eq(2)
      end
      it "Several users can have same event" do
        u1.events << e1
        u2.events << e1
        expect(u1.events.count).to eq(1)
        expect(u2.events.count).to eq(1)
      end
    end

    describe "Owner-Products" do
      it "User(as owner) should have many events (as products)" do
        u1.products << [e1, e2]
        expect(u1.products.count).to eq(2)
      end
      it "Several users(as owners) can have same event (as product)" do
        u1.products << e1
        u2.products << e1
        expect(u1.products.count).to eq(1)
        expect(u2.products.count).to eq(1)
      end
    end

    describe "Tags-Users" do
      it "User should have many tags" do
        u1.tags << [t1, t2]
        expect(u1.tags.count).to eq(2)
      end
      it "Several users can have same event" do
        u1.tags << t1
        u2.tags << t1
        expect(u1.tags.count).to eq(1)
        expect(u2.tags.count).to eq(1)
      end
    end
  end

  describe "validations" do

    let(:u) {create(:user)}
    it "Shouldn't be valid without email" do
      u.email = nil
      expect(u.valid?).to be false
    end
    it "Shouldn't be valid with wrong type of email" do
      u.email = "hohohaha.com"
      expect(u.valid?).to be false
    end
    it "Shouldn't be valid with wrong type of email" do
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
      u.password = ""
      expect(u.valid?).to be false
    end
  end

  describe "advansed methods" do
    let(:user) {create(:user)}
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
    let(:u1) {create(:filled_user)}
    let(:u2) {create(:petya_user)}
    let(:u3) {create(:vasya_user)}
    let(:u4) {create(:kolya_user)}
    let(:u5) {create(:user)}
    before(:each) do
      @u1 = create(:filled_user)
      @u2 = create(:petya_user)
      @u3 = create(:vasya_user)
      @u4 = create(:kolya_user)
      @u5 = create(:user)
    end
    it "should find all users with <valid> in name" do
      f = User.search('valid', '', '', '', '', '', '')
      expect(f.count).to eq(4)
    end
    it "should find all users with <kin> in surname" do
      f = User.search('v', 'kin', '', '', '', '', '')
      expect(f.count).to eq(3)
    end
    it "should find all users users with <male> in gender" do
      f = User.search('', '', 'male', '', '', '', '')
      expect(f.include?(u4)).to be false
      expect(f.count).to eq(3)
    end
    it "should find all users users with <1992> in year" do
      f = User.search('', '', 'male', '1992', '', '', '')
      expect(f.count).to eq(2)
    end
    it "should find all users users with <december> in month" do
      f = User.search('', '', '', '', '12', '', '')
      expect(f.count).to eq(4)
    end
    it "should find all users users with <BY> in country" do
      f = User.search('valid', '', 'male', '1992', '', 'BY', '')
      expect(f.count).to eq(2)
    end
    it "should find all users users with <HM> in city" do
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