class Project < ApplicationRecord
  belongs_to :user
  has_many :nodes, dependent: :destroy
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :nodes
end
