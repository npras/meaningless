class Discussion < ApplicationRecord
  belongs_to :site, counter_cache: true
  has_many :comments, dependent: :destroy

  def self.by_url(url)
    uri = URI.parse(url)
    where(url: uri.path).first_or_create
  end

  def like!
    update(likes: (self.likes + 1))
  end
end
