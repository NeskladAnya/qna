class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  validates :user, :value, presence: true
  validates :value, numericality: { only_integer: true }
end
