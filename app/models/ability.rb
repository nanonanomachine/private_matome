class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new
    can :read, Group, id: user.user_groups.where(role: 'member').collect(&:group_id) + Group.where(privacy: 'open').collect(&:id)
    can :create, Group
    can :update, Group, id: user.user_groups.where(role: 'moderator').collect(&:group_id)
    can :manage, Group, id: user.user_groups.where(role: 'admin').collect(&:group_id)
    can :read, List, group: { id: Group.where(privacy: 'open').collect(&:id) }
    can :manage, List, group: { id: user.user_groups.where(role: ['admin', 'moderator', 'member']).collect(&:group_id) }
    can :read, Item, group: { id: Group.where(privacy: 'open').collect(&:id) }
    can :manage, Item, list: { group: { id: user.user_groups.where(role: ['admin', 'moderator', 'member']).collect(&:group_id) } }

    # Actions in Non Restful Controller
    can [:add, :destroy], @group, user.user_groups
    can [:assign_moderator], @group, user.user_groups.where(role: ['admin', 'moderator'])
    can [:assign_admin, :assign_member], @group, user.user_groups.where(role: 'admin')
    end
end
