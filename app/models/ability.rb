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
    can :update, [Question, Answer], author_id: user.id
    can :set_best, Answer, question: { author_id: user.id }
  end
end
