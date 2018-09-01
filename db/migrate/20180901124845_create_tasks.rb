class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, default: ''
      t.string :description, null: false, default: ''
      t.string :days, array: true

      t.timestamps
    end
  end
end
