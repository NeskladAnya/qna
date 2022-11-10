# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :create_comment, [Question, Answer]
    can :like, [Question, Answer] do |likeable|
      !user.author?(likeable)
    end
    
    can :dislike, [Question, Answer] do |likeable|
      !user.author?(likeable)
    end

    can :subscribe, [Question]
    can :unsubscribe, [Question]

    can :update, [Question, Answer], author_id: user.id
    can :set_best, Answer, question: { author_id: user.id }

    can :destroy, [Question, Answer], author_id: user.id
    can :destroy, Link, linkable: { author_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    
    can :show, Reward, user_id: user.id
  end
end
