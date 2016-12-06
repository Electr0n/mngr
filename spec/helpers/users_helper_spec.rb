require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  let(:user) {create(:filled_user)}

  describe 'age' do
    it 'should return - if users bday nil' do
      u = create(:user)
      expect(age(u.bday)).to eq(' - ')
    end
    it 'should return users age' do
      expect(age(user.bday)).to eq(Time.now.year - user.bday.year)
    end
  end

  describe 'tags_list' do
    it 'should return string of users tags' do
      t1 = create(:music_tag)
      t2 = create(:sport_tag)
      user.tags << [t1, t2]
      expect(tags_list(user.tags)).to eq('Music, Sport')
    end
    it 'should return string NO TAGS if empty' do
      expect(tags_list(user.tags)).to eq('No tags')
    end
  end

  describe 'full_name' do
    it 'should return full name' do
      expect(full_name(user)).to eq('realy_valid RLYRLY')
    end
    it 'should return namee EMPTY' do
      u = create(:user)
      expect(full_name(u)).to eq('namee EMPTY')
    end
  end

  it 'info' do
    expect(info(user)).to eq('ID: ' + user.id.to_s + '. realy_valid RLYRLY')
  end

end
