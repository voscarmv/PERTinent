class AddCompleteToNode < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :complete, :boolean, default: false
  end
end
