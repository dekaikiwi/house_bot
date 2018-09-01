class LineGroup < ApplicationRecord
  scope :task_groups, -> { where(is_tasks_group: true) }
end
