FactoryGirl.define do
  factory :user do
    name "namee"
    sequence(:email) { |i| "email#{i}@email.com" }
    password "123qwe"
    # association(:event)
  end
  factory :filled_user, class: User do
  	name "realy_valid"
  	surname "RLYRLY"
  	sequence(:email) { |i| "validemail#{i}@email.com" }
  	password "123qwe"
    bday "1992-12-29"
    gender "Male"
    age 40
    phone "291363913"
    country "BY"
    city "HM"
    hobby "something"
    about "interesting"
    role "admin"
  end
  factory :invalid_user, class: User do
  	name "not_valid"
  	sequence(:email) { |i| "#{i}" }
  	password "123qwe"
    password_confirmation "123qwe"
  end
end