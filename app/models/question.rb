class Question < ApplicationRecord
  include Likeable
  include Commentable
  include Subscribable
  
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_many :subscriptions, as: :subscribable, dependent: :destroy
  has_one :reward, dependent: :destroy
  
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, :body, :author_id, presence: true
  validates :title, length: { minimum: 5 }

  after_create :calculate_reputation

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
