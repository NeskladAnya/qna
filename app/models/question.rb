class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, :body, :author_id, presence: true
  validates :title, length: { minimum: 5 }
end
