module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likeable
  end

  def like(user)
    likes.create(value: 1, user_id: user.id)
  end

  def dislike(user)
    likes.create(value: -1, user_id: user.id)
  end

  def clear_rating(user)
    likes.where(user_id: user.id).delete_all
  end

  def already_liked?(user)
    !likes.where(user_id: user.id, value: 1).empty?
  end

  def already_disliked?(user)
    !likes.where(user_id: user.id, value: -1).empty?
  end

  def final_rating
    likes.sum(:value)
  end
end
