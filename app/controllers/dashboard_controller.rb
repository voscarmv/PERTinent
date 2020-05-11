class DashboardController < ApplicationController
  def index

    if current_user
      prjid = current_user.project.first.id

      links = Link.where(project_id: prjid).pluck("from_id, to_id")
      nodes = Node.where(project_id: prjid).pluck("id")
      
      levels = []
      root = 4
      row = [root]
      levels.push(row)
      nodes = nodes.reject{|node| row.include?(node) }  
      
      while nodes.length > 0 do
        row2 =
          links.select { |edge| row.include?(edge[1]) }
          .map { |x| x[0] }
          .uniq.select{|node| nodes
          .include?(node)}
        levels.push(row2)
        links = links.reject{ |edge| row.include?(edge[1]) }
        nodes = nodes.reject{ |node| row2.include?(node) }  
        row = row2
      end

      @rows = []
      levels.each{ |lv| 
        @rows.push(Node.where("id IN (#{lv.join(',')})"))
      }



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

