FactoryGirl.define do
  factory :tag do
    name "Sport"
  end
  factory :tag_films, class: Tag do
    name "Films"
  end

end