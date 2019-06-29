class Site < ApplicationRecord
  has_many :discussions
  has_many :comments
end
