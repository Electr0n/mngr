require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Associations" do
    describe "Events-Users" do
      it "Event should have many user" do
        u1 = create(:user)
        u2 = create(:filled_user)
        e = create(:event)
        e.users << [u1, u2]
        expect(e.users.count).to eq(2)
      end
      it "Several events can have same user" do
        u = create(:user)
        e1 = create(:event)
        e2 = create(:event)
        e1.users << u
        e2.users << u
        expect(e1.users.count).to eq(1)
        expect(e2.users.count).to eq(1)
        expect(e1.users.first).to eq(e2.users.first)
      end
    end

    describe "Owner-Products" do
      it "Event (as product) should have many users(as owners)" do
        u1 = create(:user)
        u2 = create(:filled_user)
        e = create(:event)
        e.owners << [u1, u2]
        expect(e.owners.count).to eq(2)
      end
      it "Several events (as products) can have same user(as owner) " do
        u = create(:user)
        e1 = create(:event)
        e2 = create(:event)
        e1.owners << u
        e2.owners << u
        expect(e1.owners.count).to eq(1)
        expect(e2.owners.count).to eq(1)
      end
    end

    describe "Tags-Events" do
      it "Event should have many tags" do
        e = create(:event)
        t1 = create(:tag)
        t2 = create(:tag)
        e.tags << [t1, t2]
        expect(e.tags.count).to eq(2)
      end
      it "Several users can have same event" do
        e1 = create(:event)
        e2 = create(:event)
        t = create(:tag)
        e1.tags << t
        e2.tags << t
        expect(e1.tags.count).to eq(1)
        expect(e2.tags.count).to eq(1)
      end
    end

    describe "validations" do
      it "shouldn't be valid: too short name" do
        e = create(:event)
        e.name = "oops"
        expect(e.valid?).to be false
      end
      it "shouldn't be valid: too long name" do
        e = create(:event)
        e.name = "it's should be greater than 100 symbols to be not valid if I want this validation name longest test work fine"
        expect(e.valid?).to be false
      end
      it "shouldn't be valid: agemin, agemax, number should be greater 0" do
        e = create(:event)
        e.agemax = -2
        e.agemin = -1
        e.number = "idk"
        expect(e.valid?).to be false
      end
    end
  end
end