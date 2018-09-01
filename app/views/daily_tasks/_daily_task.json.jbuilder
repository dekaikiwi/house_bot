json.extract! daily_task, :id, :line_user_id, :task_id, :is_completed, :created_at, :updated_at
json.url daily_task_url(daily_task, format: :json)
