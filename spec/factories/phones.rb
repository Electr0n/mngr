FactoryGirl.define do

  factory :phone, class: Phone do
    code          111
    number        222222222
    description  'mts'
  end

  factory :phone_1, class: Phone do
    code          222
    number        333333333
    description  'life'
  end

  factory :phone_2, class: Phone do
    code          375
    number        1363912
    description  'velcom'
  end

end
