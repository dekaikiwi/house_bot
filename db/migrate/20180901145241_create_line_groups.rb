class CreateLineGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :line_groups do |t|
      t.string :line_id

      t.timestamps
    end
  end
end
