# class Ability
#   include CanCan::Ability
#
#   # def initialize(user)
#   #   # Define abilities for the passed in user here. For example:
#   #   #
#   #   #   user ||= User.new # guest user (not logged in)
#   #   #   if user.admin?
#   #   #     can :manage, :all
#   #   #   else
#   #   #     can :read, :all
#   #   #   end
#   #   #
#   #   # The first argument to `can` is the action you are giving the user
#   #   # permission to do.
#   #   # If you pass :manage it will apply to every action. Other common actions
#   #   # here are :read, :create, :update and :destroy.
#   #   #
#   #   # The second argument is the resource the user can perform the action on.
#   #   # If you pass :all it will apply to every resource. Otherwise pass a Ruby
#   #   # class of the resource.
#   #   #
#   #   # The third argument is an optional hash of conditions to further filter the
#   #   # objects.
#   #   # For example, here the user can only update published articles.
#   #   #
#   #   #   can :update, Article, :published => true
#   #   #
#   #   # See the wiki for details:
#   #   # https://github.com/ryanb/cancan/wiki/Defining-Abilities
#   # end
# end
require 'cancancan'

class Ability
  include CanCan::Ability

  def initialize(user)
    # user.role.role_abilities.each do |ability|
    #   ability["action"].each do |m|
    #     Rails.logger.debug("In the abilities folder #{m.to_sym}")
    #   can [:create_user], User
    #   end
    # end
    # if user.role.role_name == "Create User"
    #   can [:create_user,:edit_appointment], :UserApi
    # end
    # return unless user.present?
    # user ||= User.find_by()
    # Rails.logger.debug("THE ABILITIES ARE***************** #{user}")
    # user.role.role_abilities.each do |ability|
    #   Rails.logger.debug("In the abilities folder #{ability["action"]}")
    #   can ability["action"], ability["subject"]
    # end

    user.roles.each do |role|
      r = Role.find(role)
      r.role_abilities.each do |ability|
        can ability["action"], ability["subject"]
      end
    end



  end
end


# r.role_abilities.each do |a|
#       a["action"].each do |m|
#            print m.to_sym
#        end
#   end