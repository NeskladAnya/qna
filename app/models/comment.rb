class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates :body, :author, presence: true

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )
end
