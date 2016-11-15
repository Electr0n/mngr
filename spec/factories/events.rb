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
    number -100
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

  factory :party_event, class: Event do
    name "party"
    date "10 Dec 2010"
    time "21:34"
    description "birthday party!!"
    gender "female"
    agemin 0
    agemax 150
    number 194673
    location "Suharevskaya str"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
  factory :concert_event, class: Event do
    name "concert"
    date "10 Dec 2017"
    time "10:34"
    description "Linkin Park"
    gender "male"
    agemin 0
    agemax 50
    number 100
    location "Zybickaya str"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
  factory :box_event, class: Event do
    name "boxxxx"
    date "10 Dec 2018"
    time "21:34"
    description "Rocky Balboa bv Tramp"
    gender "NA"
    agemin 18
    agemax 150
    number 6000
    location "Chizhovka arena"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
  factory :dating_event, class: Event do
    name "speed dating"
    date "15 Dec 2020"
    time "21:34"
    description "Find your love!"
    gender "NA"
    agemin 18
    agemax 40
    number 50
    location "Frunzenskaya 45"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
  factory :football_event, class: Event do
    name "football"
    date "10 Dec 2018"
    time "22:00"
    description "Arsenal - Barcelona, chempion leage cup"
    gender "na"
    agemin 0
    agemax 150
    number 10
    location "Suharevskaya str"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
  factory :beer_event, class: Event do
    name "beer fest"
    date "10 Dec 2018"
    time "11:34"
    description "A lot of beer, sosages and girls!"
    gender "NA"
    agemin 18
    agemax 150
    number 500
    location "Oktyabrskaya str"
    latitude 0.0
    longitude 0.0
    del_flag 'false'
  end
end