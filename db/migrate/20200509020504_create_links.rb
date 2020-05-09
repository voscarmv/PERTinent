class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.integer :from_id
      t.integer :to_id
      t.integer :user_id

      t.timestamps
    end
  end
end
