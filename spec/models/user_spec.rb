require "rails_helper"

RSpec.describe User, type: :model do 

  describe "Associations" do
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
        e1 = create(:tag)
        e2 = create(:tag)
        u.tags << [e1, e2]
        expect(u.tags.count).to eq(2)
      end
      it "Several users can have same event" do
        u1 = create(:user)
        u2 = create(:user)
        e = create(:tag)
        u1.tags << e
        u2.tags << e
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

  describe "permited attributes" do
    let(:user) {u = create(:user)}
    it "should update name" do
      user.name = "Alibaba"
      expect(user.name).to eq("Alibaba")
    end
    it "should update surname" do
      user.surname = "Alibaba"
      expect(user.surname).to eq("Alibaba")
    end
    it "should update email" do
      user.email = "Go@home.yanki"
      expect(user.email).to eq("Go@home.yanki")
    end
    it "should update birthday" do
      user.bday = "29 Dec 1992"
      expect(user.bday.strftime('%F') ).to eq("1992-12-29")
    end
    it "should update gender" do
      user.gender = "Male"
      expect(user.gender).to eq("Male")
    end
    it "should update age" do
      user.age = "18"
      expect(user.age).to eq(18)
    end
    it "should update phone" do
      user.phone = 291363912
      expect(user.phone).to eq(291363912)
    end
    it "should update hobby" do
      user.hobby = "I love crocodiles"
      expect(user.hobby).to eq("I love crocodiles")
    end
    it "should update about" do
      user.about = "I'm programmer"
      expect(user.about).to eq("I'm programmer")
    end
    it "should update password" do
      user.password = "Alibaba"
      expect(user.password).to eq("Alibaba")
    end
    it "should update password confirmation" do
      user.password_confirmation = "Alibaba"
      expect(user.password_confirmation).to eq("Alibaba")
    end
    it "should update avatar" do
      user.avatar = File.open("#{Rails.root}/public/favicon.ico")
      expect(user.avatar_file_name).to eq("favicon.ico")
    end
    it "should update country" do
      user.country = "BY"
      expect(user.country).to eq("BY")
    end
    it "should update city" do
      user.city = "HM"
      expect(user.city).to eq("HM")
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