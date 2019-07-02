class Site < ApplicationRecord
  has_many :discussions
  has_many :comments

  def self.by_url(url)
    uri = URI.parse(url)
    find_by(domain: "#{uri.host}:#{uri.port}")
  end
end
