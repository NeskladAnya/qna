class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, :author_id, presence: true
  validates :title, length: { minimum: 5 }
end
