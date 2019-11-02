json.extract! profile, :user_id, :first, :last, :description, :song, :preference, :gender, :value, :priority, :created_at, :updated_at
json.url profile_url(profile, format: :json)
