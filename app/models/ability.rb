class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, :all if user.roles.find_by_name('superadmin')
    if user.roles.find_by_name('admin')
      can :manage, :all
      cannot :destroy, :all
    end
    if user.roles.find_by_name('moderator')
      can :read, [User, Event]
      can :del_request, User
      can [:create, :edit, :update], Event
    end
    if user.roles.find_by_name('user')
      can :read, :all
      can :create, Event
      can [:edit, :update, :del_request], User do |u|
        u == user
      end
      can [:edit, :update], Event do |e|
        user.events.include? e
      end
    end
  end
end