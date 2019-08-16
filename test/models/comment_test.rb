require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  body          :text
#  email         :string
#  ip_address    :string
#  name          :string
#  referrer      :string
#  user_agent    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discussion_id :bigint           not null
#  site_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_discussion_id  (discussion_id)
#  index_comments_on_site_id        (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (discussion_id => discussions.id)
#  fk_rails_...  (site_id => sites.id)
#
