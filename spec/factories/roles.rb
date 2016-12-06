FactoryGirl.define do

  factory :role_superadmin, class: Role do
    name 'superadmin'
  end

  factory :role_admin, class: Role do
    name 'admin'
  end

  factory :role_user, class: Role do
    name 'user'
  end

  factory :role_moderator, class: Role do
    name 'moderator'
  end

  factory :role_banned, class: Role do
    name 'banned'
  end
end
