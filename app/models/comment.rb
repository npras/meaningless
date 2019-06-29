class Comment < ApplicationRecord
  belongs_to :site, counter_cache: true
  belongs_to :discussion, counter_cache: true
end
