class User < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: :author_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
