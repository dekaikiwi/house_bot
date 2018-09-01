class AddTaskGroupOptionToLineGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :line_groups, :is_tasks_group, :boolean
  end
end
