class AddUserToLinks < ActiveRecord::Migration[6.0]
  def change
    add_reference :links, :project, null: false, foreign_key: true
  end
end
