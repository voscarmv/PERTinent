class AddUserToNodes < ActiveRecord::Migration[6.0]
  def change
    add_reference :nodes, :project, null: false, foreign_key: true
  end
end
