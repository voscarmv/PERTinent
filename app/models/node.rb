class Node < ApplicationRecord
  before_destroy :check_if_root
  class Error < StandardError
  end

  has_many :pomodoro
  
  has_many :to_links, foreign_key: :from_id, class_name: :Link, dependent: :destroy
  has_many :to_nodes, through: :to_links  

  has_many :from_links, foreign_key: :to_id, class_name: :Link #tricky!
  has_many :from_nodes, through: :from_links

  belongs_to :project

  accepts_nested_attributes_for :to_links

  def check_if_root
    unless destroyed_by_association
      root = Node.where(project_id: project_id).order(:created_at).limit(1).first.id
      if from_nodes.exists?
        raise Error.new "Can't delete parent node."
      end
      if id == root
        raise Error.new "Can't delete root node."
      end
    end
  end
end
