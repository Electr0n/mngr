require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  let(:event) {create(:event)}
  let(:party) {create(:party_event)}
  
  context "age_max?" do
    it "should return true if age_max <150" do
      expect(age_max?(event.agemax)).to be true
    end
    it "should return false if age_max >=150" do
      expect(age_max?(party.agemax)).to be false
    end
  end

  context "age_min?" do
    it "should return true if age_min > 0" do
      expect(age_min?(event.agemin)).to be true
    end
    it "should return false if age_min <= 0" do
      expect(age_min?(party.agemin)).to be false
    end
  end

  context "number?" do
    it "should return true if number < 194673" do
      expect(number?(event.number)).to be true
    end
    it "should return false if number >= 194673" do
      expect(number?(party.number)).to be false
    end
  end

  context 'number' do
    it 'should return number if < 194673' do
      expect(number(event.number)).to eq(20)
    end
    it 'should return string if >= 194673' do
      expect(number(party.number)).to eq(' > 100 000')
    end
  end

  context 'age_range' do
    it 'should return string with age range' do
      expect(age_range(event.agemin, event.agemax)).to eq('10 - 50')
    end
    it 'should return string if user do not care' do
      e = create(:party_event)
      expect(age_range(e.agemin, e.agemax)).to eq('0+ - 99+')
    end
  end

  context 'tags list' do
    it 'should print NO TAGS if tags empty' do
      expect(tags_list(event.tags)).to eq('No tags')
    end
    it 'should print string of tags if not empty' do
      t1 = create(:sport_tag)
      t2 = create(:music_tag)
      event.tags << [t1, t2]
      expect(tags_list(event.tags)).to eq('Sport, Music')
    end
  end
end
