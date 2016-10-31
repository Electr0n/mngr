require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Associations" do
    let(:u1) {create(:user)}
    let(:u2) {create(:filled_user)}
    let(:e1) {create(:event)}
    let(:e2) {create(:filled_event)}
    let(:t1) {create(:tag_films)}
    let(:t2) {create(:tag)}
    context "Events-Users" do
      it "Event should have many user" do
        e1.users << [u1, u2]
        expect(e1.users.count).to eq(2)
      end
      it "Several events can have same user" do
        e1.users << u1
        e2.users << u1
        expect(e1.users.count).to eq(1)
        expect(e2.users.count).to eq(1)
        expect(e1.users.first).to eq(e2.users.first)
      end
    end

    context "Owner-Products" do
      it "Event (as product) should have many users(as owners)" do
        e1.owners << [u1, u2]
        expect(e1.owners.count).to eq(2)
      end
      it "Several events (as products) can have same user(as owner) " do
        e1.owners << u1
        e2.owners << u1
        expect(e1.owners.count).to eq(1)
        expect(e2.owners.count).to eq(1)
      end
    end

    context "Tags-Events" do
      it "Event should have many tags" do
        e1.tags << [t1, t2]
        expect(e1.tags.count).to eq(2)
      end
      it "Several users can have same event" do
        e1.tags << t1
        e2.tags << t1
        expect(e1.tags.count).to eq(1)
        expect(e2.tags.count).to eq(1)
      end
    end
  end

  describe "validations" do
    let(:e) {create(:event)}
    it "shouldn't be valid: too short name" do
      e.name = "oops"
      expect(e.valid?).to be false
    end
    it "shouldn't be valid: too long name" do
      e.name = "it's should be greater than 100 symbols to be not valid if I want this validation name longest test work fine"
      expect(e.valid?).to be false
    end
    it "shouldn't be valid: agemin, agemax, number should be greater 0" do
      e.agemax = -2
      e.agemin = -1
      e.number = "idk"
      expect(e.valid?).to be false
    end
  end
end