class CreateLineUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :line_users do |t|
      t.string :line_id
      t.string :line_username
      t.string :string

      t.timestamps
    end
  end
end
