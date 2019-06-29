class Discussion < ApplicationRecord
  belongs_to :site, counter_cache: true
  has_many :comments
end
