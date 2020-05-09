class Link < ApplicationRecord
  belongs_to :from_node, foreign_key: :from_id, class_name: :Node 
  belongs_to :to_node, foreign_key: :to_id, class_name: :Node 
end
