class Pomodoro < ApplicationRecord
  belongs_to :node
  has_rich_text :content
end
