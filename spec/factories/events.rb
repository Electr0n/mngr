FactoryGirl.define do
	factory :event do
		name "event_name"
		agemin 10
		agemax 50
		number 20
		#association(:user)
	end
end