FactoryGirl.define do
  # valid event
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
  factory :filled_event, class: Event do
    name "birthday"
    date "10 Dec 2030"
    time "21:34"
    description "Description is here"
    gender "female"
    agemin 20
    agemax 20
    number 20
    location "Suharevskaya str"
    latitude 0.0
    longitude 0.0
    del_flag 'true'
  end
end