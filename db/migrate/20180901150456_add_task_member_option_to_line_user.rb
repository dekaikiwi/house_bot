class AddTaskMemberOptionToLineUser < ActiveRecord::Migration[5.1]
  def change
    add_column :line_users, :is_tasks_user, :boolean
  end
end
