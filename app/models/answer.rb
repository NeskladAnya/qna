class Answer < ApplicationRecord
  has_one :reward
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, :question_id, :author_id, presence: true
end
