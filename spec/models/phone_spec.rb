require 'rails_helper'

RSpec.describe Phone, type: :model do
  
  describe 'association Phone-User' do

    let(:u1) {create(:user)}
    let(:u2) {create(:filled_user)}
    let(:p1) {create(:phone)}
    let(:p2) {create(:phone_1)}
    let(:p3) {create(:phone_2)}

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

  describe 'validations' do
    
    let(:p) {create(:phone)}

    before{
      p
    }

    context 'number' do

      it 'shouldnt update: too short' do
        p.update_attributes(number: 44)
        p.reload
        expect(Phone.last.number).to eq(222222222)
      end

      it 'shouldnt update: too large' do
        p.update_attributes(number: 4444444444411111)
        p.reload
        expect(Phone.last.number).to eq(222222222)
      end

      it 'cannt be less than 0' do
        p.update_attributes(number: -1)
        p.reload
        expect(Phone.last.number).to eq(222222222)
      end

      it 'can be only integer' do
        p.update_attributes(number: 'asdasd')
        p.reload
        expect(Phone.last.code).to eq(111)
      end

    end

    context 'descriptions' do

      it 'can not be more than 50 characters' do
        p.update_attributes(description: 'LEROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOY JEEENKIIIIIIINS')
        p.reload
        expect(Phone.last.description).to eq('mts')
      end

    end

    context 'code' do

      it 'cant have mor than 3 symbols' do
        p.update_attributes(code: 1234)
        p.reload
        expect(Phone.last.code).to eq(111)
      end

      it 'cant have < 1 symbols' do
        p.update_attributes(code: '')
        p.reload
        expect(Phone.last.code).to eq(111)
      end

      it 'cant be less than 0' do
        p.update_attributes(code: -1)
        p.reload
        expect(Phone.last.code).to eq(111)
      end

      it 'can be only integer' do
        p.update_attributes(code: 'asd')
        p.reload
        expect(Phone.last.code).to eq(111)
      end

    end

  end

end
