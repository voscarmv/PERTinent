class DashboardController < ApplicationController
  def index

    if current_user
      @edges = Link.find_by user_id: current_user.id
    end
    
  end
end


# a = Node.create(:name => "a", :project_id => 1)
# b = Node.create(:name => "b", :project_id => 1)
# c = Node.create(:name => "c", :project_id => 1)
# d = Node.create(:name => "d", :project_id => 1)
# Link.create(:from_node => a, :to_node => b, :project_id => 1)
# Link.create(:from_node => b, :to_node => c, :project_id => 1)
# Link.create(:from_node => c, :to_node => d, :project_id => 1)
# Link.create(:from_node => b, :to_node => d, :project_id => 1)
# Link.create(:from_node => d, :to_node => a, :project_id => 1)