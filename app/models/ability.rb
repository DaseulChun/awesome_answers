# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # Cancancan assumes you have a method called `current_user`
  # available in your ApplicationController (which we do).
  # Cancancan gets automatically initialized with `current_user`
  # passed to the initialize method.

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities


    # To define a permission for a user, use the 'can' method inside
    # of this classes, initialize method. It takes the following args
    # (in order):
    # - The name of the action you are testing for as a symbol
    # - The class of an object we are testing against.
    # - A block that is used to determine whether or not a user can perform said action
    
    # If the block returns true, the user can perform the action, otherwise they can't

    if user.is_admin?
      can :manage, :all 
      # manage means they can do everything (not just CRUD)
    end

    alias_action :create, :read, :edit, :update, :destroy, to: :crud

    can :crud, Question do |question|
      question.user == user
    end

    # We can also write abilities like:
    # can :crud, Question, use_id: user.id

    can :crud, Answer do |answer|
      answer.user == user
    end

  end
end
