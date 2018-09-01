class LineUser < ApplicationRecord
  scope :task_users, -> { where(is_tasks_user: true) }
end
