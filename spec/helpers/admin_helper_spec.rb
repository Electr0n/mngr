require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AdminHelper. For example:
#
# describe AdminHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AdminHelper, type: :helper do
  
  let(:role_banned) {create(:role_banned)}

  before { role_banned }

  it 'should be link to ban' do
    u = create(:filled_user)
    expect(ban_button(u)).to eq(link_to 'ban', ban_admin_path(u))
  end

  it 'sohuld be link to unban' do
    u = create(:filled_user)
    u.roles << role_banned
    expect(ban_button(u)).to eq(link_to 'unban', unban_admin_path(u))
  end

end
