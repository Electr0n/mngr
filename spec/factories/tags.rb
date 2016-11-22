FactoryGirl.define do
  factory :tag do
    name "Sport"
  end
  factory :tag_films, class: Tag do
    name "Films"
  end

  factory :dating_tag, class: Tag do
    name "Dating"
  end
  factory :sport_tag, class: Tag do
    name "Sport"
  end
  factory :music_tag, class: Tag do
    name "Music"
  end
  factory :party_tag, class: Tag do
    name "Party"
  end
  factory :drink_tag, class: Tag do
    name "Drink"
  end
end