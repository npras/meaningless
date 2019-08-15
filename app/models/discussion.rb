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

# == Schema Information
#
# Table name: discussions
#
#  id             :bigint           not null, primary key
#  comments_count :integer          default(0)
#  likes          :integer          default(0)
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  site_id        :bigint           not null
#
# Indexes
#
#  index_discussions_on_site_id          (site_id)
#  index_discussions_on_site_id_and_url  (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
