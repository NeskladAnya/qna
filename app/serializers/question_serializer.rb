class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_one :reward
  has_many :answers
  has_many :links
  has_many :comments
  has_many :files
  belongs_to :author, class_name: 'User'

  def short_title
    object.title.truncate(7)
  end
end
