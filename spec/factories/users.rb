FactoryGirl.define do
  factory :user do
    name "namee"
    sequence(:email) { |i| "email#{i}@email.com" }
    password "123qwe"
  end
  factory :filled_user, class: User do
    name "realy_valid"
    surname "RLYRLY"
    sequence(:email) { |i| "filled#{i}@email.com" }
    password "123qwe"
    bday "1992-12-29"
    gender "Male"
    phone "291363913"
    country "BY"
    city "HM"
    hobby "something"
    about "interesting"
  end
  factory :petya_user, class: User do
    name "petya_valid"
    surname "pupkin"
    sequence(:email) { |i| "petya#{i}@gmail.com" }
    password "123qwe"
    bday "1992-12-29"
    gender "Male"
    phone "291363913"
    country "BY"
    city "HM"
    hobby "something"
    about "interesting"
  end
  factory :vasya_user, class: User do
    name "vasya_valid"
    surname "tutkin"
    sequence(:email) { |i| "vasya#{i}@gmail.com" }
    password "123qwe"
    bday "1994-12-29"
    gender "Male"
    phone "291363913"
    country "BY"
    city "HM"
    hobby "something"
    about "interesting"
  end
  factory :kolya_user, class: User do
    name "kolya_valid"
    surname "zalupkin"
    sequence(:email) { |i| "kolya#{i}@gmail.com" }
    password "123qwe"
    bday "1990-12-29"
    gender "Female"
    phone "291363913"
    country "BY"
    city "HM"
    hobby "something"
    about "interesting"
  end
  factory :invalid_user, class: User do
    name "not_valid"
    sequence(:email) { |i| "#{i}" }
    password "123qwe"
    password_confirmation "123qwe"
  end
end