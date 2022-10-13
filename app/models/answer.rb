class Answer < ApplicationRecord
  include Likeable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, :question_id, :author_id, presence: true
end
