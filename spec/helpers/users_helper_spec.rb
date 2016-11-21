require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  let(:user) {create(:filled_user)}
  before {
      @user = user
    }

  it "calculate users age" do
    expect(users_age).to eq(23)
  end
end
