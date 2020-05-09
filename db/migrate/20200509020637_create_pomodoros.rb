class CreatePomodoros < ActiveRecord::Migration[6.0]
  def change
    create_table :pomodoros do |t|
      t.text :content
      t.integer :node_id
      t.integer :user_id

      t.timestamps
    end
  end
end
