require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  let(:event) {create(:event)}
  before {
      @event = event
    }

  context "agemax check" do
    it "should return true if agemax <150" do
      @event.agemax = '50'
      expect(agemax_check).to be true
    end
    it "should return false if agemax >=150" do
      @event.agemax = '150'
      expect(agemax_check).to be false
    end
  end

  context "agemin check" do
    it "should return true if agemin >= 0" do
      @event.agemin = '0'
      expect(agemin_check).to be true
    end
    it "should return false if agemin < 0" do
      @event.agemin = '-150'
      expect(agemin_check).to be false
    end
  end

  context "number check" do
    it "should return true if number < 194673" do
      @event.number = '50'
      expect(number_check).to be true
    end
    it "should return false if number >= 194673" do
      @event.number = '194673'
      expect(number_check).to be false
    end
  end
end
