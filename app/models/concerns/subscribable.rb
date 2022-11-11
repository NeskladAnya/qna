module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy, as: :subscribable
  end

  def add_subscription(user)
    subscriptions.create(user_id: user.id)
  end

  def remove_subscription(user)
    subscriptions.where(user_id: user.id, subscribable: self).delete_all
  end

  def already_subscribed?(user)
    subscriptions.where(user_id: user.id, subscribable: self).empty? ? false : true
  end
end
