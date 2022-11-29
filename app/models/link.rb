class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true

  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    url.include?('gist.github.com')
  end
end
