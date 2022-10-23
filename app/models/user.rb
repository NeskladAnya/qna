class User < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: :author_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id, dependent: :destroy
  has_many :rewards
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  
  def author?(resource)
    self.id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
