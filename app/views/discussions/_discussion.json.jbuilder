json.extract! discussion, :id, :url, :title, :comments_count, :site_id, :created_at, :updated_at
json.url discussion_url(discussion, format: :json)
