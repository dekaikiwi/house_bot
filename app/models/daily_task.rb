class DailyTask < ApplicationRecord
  belongs_to :line_user
  belongs_to :task

  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }
end
