class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
    end
    if user.admin?
      can :manage, :all
      cannot :destroy, :all
    end
    if user.moderator?
      can :read, [User, Event]
      can :del_request, User
      can [:edit, :update, :del_request], User do |u|
        u == user
      end
      can [:create, :edit, :update, :del_request], Event
    end
    if user.user?
      can :read, :all
      can :create, Event
      can [:edit, :update, :del_request], User do |u|
        u == user
      end
      can [:edit, :update, :del_request], Event do |e|
        user.products.include? e
      end
    end
  end
end