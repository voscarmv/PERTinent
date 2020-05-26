class RemoveContentFromPomodoro < ActiveRecord::Migration[6.0]
  def change
    remove_column :pomodoros, :content, :text
  end
end
