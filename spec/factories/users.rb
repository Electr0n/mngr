FactoryGirl.define do
	factory :user do
		name "name"
		sequence(:email) { |i| "email#{i}@email.com" }
		password "password"
		#association(:event)
	end
end