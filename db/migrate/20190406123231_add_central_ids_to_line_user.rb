class AddCentralIdsToLineUser < ActiveRecord::Migration[5.1]
  def change
    add_column :line_users, :central_ids, :integer, array: true
  end
end
