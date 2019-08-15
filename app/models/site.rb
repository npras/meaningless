class Site < ApplicationRecord
  has_many :discussions
  has_many :comments

  def self.by_url(url)
    uri = URI.parse(url)
    find_by(domain: "#{uri.host}:#{uri.port}")
  end
end

# == Schema Information
#
# Table name: sites
#
#  id                :bigint           not null, primary key
#  comments_count    :integer          default(0)
#  discussions_count :integer          default(0)
#  domain            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_sites_on_domain  (domain) UNIQUE
#
