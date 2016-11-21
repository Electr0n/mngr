FactoryGirl.define do
  factory :tag do
    name "Sport"
  end
  factory :tag_films, class: Tag do
    name "Films"
  end

  factory :dating_tag, class: Tag do
    name "dating"
  end
  factory :sport_tag, class: Tag do
    name "sport"
  end
  factory :music_tag, class: Tag do
    name "music"
  end
  factory :party_tag, class: Tag do
    name "party"
  end
  factory :drink_tag, class: Tag do
    name "drink"
  end
end