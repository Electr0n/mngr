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
    let(:p1) {create(:phone)}
    let(:p2) {create(:phone_1)}
    let(:p3) {create(:phone_2)}

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

    before {
      u1.phones << [p1, p3]
      u2.phones << p2
    }

    it 'user cant have same phone' do
      u2.phones << p1
      expect(u1.phones.count).to eq(1)
      expect(u2.phones.count).to eq(2)
    end

    it 'phone cant have 1 user' do
      p1.user_id = u2.id
      p1.save
      p1.reload
      expect(u1.phones.count).to eq(1)
      expect(u2.phones.count).to eq(2)
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
    let(:user) {create(:filled_user)}
    
    it "should return full country name" do
      expect(user.country_).to eq("Belarus")
    end
    it "should return full city name" do
      expect(user.city_).to eq("Horad Minsk")
    end

    context 'age' do
      it 'should calculate age' do
        expect(user.age).to eq(Time.now.year - user.bday.year)
      end
      it 'should return nil if bday.nil?' do
        u = create(:user)
        expect(u.age).to be nil
      end
    end
  end

  describe "omniauth" do
    let(:role) {create(:role_user)}
    before {
      role
    }
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

  describe 'check roles' do
    let(:user) {create(:filled_user)}
    let(:r1) {create(:role_user)}
    let(:r2) {create(:role_moderator)}
    let(:r3) {create(:role_admin)}
    let(:r4) {create(:role_superadmin)}
    before {
      [r1, r2, r3, r4]
    }
    it 'superadmin? should return true for superadmin' do
      user.roles << r4
      expect(user.superadmin?).to be true
    end
    it 'superadmin? should return false for not superadmin' do
      user.roles << [r1, r2, r3]
      expect(user.superadmin?).to be false
    end
    it 'admin? should return true for admin' do
      user.roles << r3
      expect(user.admin?).to be true
    end
    it 'admin? should return false for not admin' do
      user.roles << [r1, r2, r4]
      expect(user.admin?).to be false
    end
    it 'moderator? should return true for moderator' do
      user.roles << r2
      expect(user.moderator?).to be true
    end
    it 'moderator? should return false for not moderator' do
      user.roles << [r1, r4, r3]
      expect(user.moderator?).to be false
    end
    it 'user? should return true for user' do
      user.roles << r1
      expect(user.user?).to be true
    end
    it 'user? should return false for not user' do
      user.roles << [r4, r2, r3]
      expect(user.user?).to be false
    end
  end

end