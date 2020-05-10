class RemoveUserIdFromNodes < ActiveRecord::Migration[6.0]
  def change
    remove_column :nodes, :user_id, :integer
  end
end
