FactoryGirl.define do
  factory :event do
    name "valid_event"
    agemin 10
    agemax 50
    number 20
    #association(:user)
  end
  # invalid event
  factory :_event, class: Event do
  	name "invalid_event"
  	agemin 10
  	agemax 50
  	number nil
  end
end