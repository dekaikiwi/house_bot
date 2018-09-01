class CreateDailyTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_tasks do |t|
      t.references :line_user, foreign_key: true
      t.references :task, foreign_key: true
      t.boolean :is_completed

      t.timestamps
    end
  end
end
