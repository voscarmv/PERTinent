class Link < ApplicationRecord
  before_destroy :check_if_orphan
  class Error < StandardError
  end

  belongs_to :from_node, foreign_key: :from_id, class_name: :Node 
  belongs_to :to_node, foreign_key: :to_id, class_name: :Node 

  belongs_to :project

  def check_if_orphan
    unless destroyed_by_association
      unless Link.last.from_node.to_nodes.count > 1
        raise Error.new "Can't leave orphaned node."
      end  
    end
  end
end
