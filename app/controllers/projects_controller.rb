class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if current_user
      prjid = @project.id

      edges = Link.where(project_id: prjid).pluck("from_id, to_id")
      nodes = Node.where(project_id: prjid).pluck("id").push(-1)
      startnode = -1
      endnode = Node.where(project_id: prjid).order(:created_at).limit(1).first.id

      # Add an artificial start node
      startpoints = Node.where(project: prjid).includes(:from_links).references(:from_links).where(links: {id: nil}).pluck("id")
      edges += startpoints.map{|n| [startnode, n]}
      edges2 = edges.dup

      pnd = []
      nextnodes = [startnode]

      # p edges
      # p nodes
      # p startnode
      # p endnode
      # p nextnodes
      # p startpoints

      # return
      
      until nextnodes.empty?
        v = nextnodes[0]
        nextnodes.delete(v)
      
        neighboredges = edges.select{|e| e[0] == v }
        neighboredges.sort_by!{|x, y| y}
        pnd += neighboredges
      
        neighboredges.each{ |e|
          edges.delete(e)
          neighbor = e[1]
          incoming = edges.select{|e| e[1] == neighbor}
          p incoming
          if incoming.empty?
            nextnodes.push(neighbor)
          end
        }
      end
      
      prev = pnd[0][0]
      nest1 = 1
      pnd.map! { |e|
        if e[0] != prev
          nest1 += 1
          prev = e[0]
        end
        e = [e, nest1]
      }
      
      p pnd
      
      # pnd = [
      #   [[1, 2], 1],
      #   [[1, 3], 1],
      #   [[1, 4], 1],
      #   [[2, 3], 2],
      #   [[2, 5], 2],
      #   [[4, 5], 3],
      #   [[3, 5], 4]  
      # ]
      
      # nodes = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      # pnd = [
      #   [[1, 2], 1],
      #   [[1, 3], 1],
      #   [[1, 4], 1],
      #   [[2, 5], 2],
      #   [[3, 5], 3],
      #   [[4, 5], 4],
      #   [[5, 6], 5],
      #   [[5, 7], 5],
      #   [[5, 8], 5],
      #   [[6, 9], 6],
      #   [[7, 9], 7],
      #   [[8, 9], 8],
      # ]
      
      table = Array.new(nodes.length*2){Array.new(1,0)}
      
      pnd.each{ |activity|
      
        puts "TABLE START"
        table.each{ |r|
          p r
        }
      
        startnode = activity[0][0]
        nest1s = activity[1]
      
        endnode = activity[0][1]
        ix = pnd.index { |a| a[0][0] == endnode }
      
        if ix
          nest1e = pnd[ix][1]
        else
          nest1e = nodes.length
        end
      
        ####
        nest1s *= 2
        nest1e *= 2
        ####
      
        puts "#{startnode},#{endnode}"
        x1 = table[nest1s - 1].index {|c| c != 0}
        x2 = table[nest1s - 2].index {|c| c != 0}
        x = x1 || x2
        unless x
          x = 0
        end
        cols = table.transpose
      
        found = false
        while x < cols.length do
          puts "colx"
          c2 = cols[x].clone
          c2[nest1e-1] = "E"
          c2[nest1s] = "S"
          p c2
          cols[x].delete_at(nest1e-1)
          cols[x].shift(nest1s)
          p cols[x]
          if cols[x].all?(0)
            table[nest1s-1][x] = startnode
            ###
            table[nest1e-2][x] = endnode
            ###
            found = true
            puts "found1"
            break
          end
          x += 1
        end
        until found do
          table.each{ |row|
            row.push(0)
          }
          cols = table.transpose
          cols[x].delete_at(nest1e-1)
          cols[x].shift(nest1s)
          if cols[x].all?(0)
            table[nest1s-1][x] = startnode
            ###
            table[nest1e-2][x] = endnode
            ###
            found = true
            puts "found2"
          end
          x += 1    
        end
      
        puts "TABLE END"
        table.each{ |r|
          p r
        }
      }
      
      puts "FINAL TABLE"
      table.each{ |r|
        puts r.join("\t")
      }
      
      # return "exit"
      
      plot = Array.new()
      
      plot.push(Array.new(table[0].length,"   "))
      i = 1
      table_index = 0
      cols = table.transpose
      
      (table.length/2).times{
        5.times{
          plot.push(Array.new(table[0].length,"   "))
        }
      
        row_incoming = table[table_index]
        row_outgoing = table[table_index + 1]
      
        incoming_first = row_incoming.index{|c| c != 0}
        outgoing_first = row_outgoing.index{|c| c != 0}
      
        if incoming_first.nil?
          first = outgoing_first
          node = row_outgoing[outgoing_first]
        elsif outgoing_first.nil?
          first = incoming_first
          node = row_incoming[incoming_first]
        else
          first = [incoming_first, outgoing_first].min
          node = row_incoming[incoming_first]
        end
      
        start_in = false
        first_in = true
        puts "row in #{row_incoming}"
      
        row_incoming.reverse.each_with_index{ |ri, j|
          ix = row_incoming.length - 1 - j
          if ix == first
            plot[i][ix] = "---"
            plot[i+1][ix] = node
            break
          end
          if ri != 0
            start_in = true
          end
          if start_in
            if first_in
              plot[i][ix] = "<< "
              first_in = false
            else
              if ri != 0
                plot[i][ix] = "<v<"
              else
                plot[i][ix] = "<<<"
              end
            end
          end
        }
      
        start_in = false
        first_in = true
        row_outgoing.reverse.each_with_index{ |ro, j|
          ix = row_incoming.length - 1 - j
          if ix == first
            plot[i+2][ix] = "---"
            break
          end
          if ro != 0
            start_in = true
          end
          if start_in
            if first_in
              plot[i+2][ix] = ">> "
              first_in = false
            else
              if ro != 0
                plot[i+2][ix] = ">v>"
              else
                plot[i+2][ix] = ">>>"
              end
            end
          end
        }
      
        puts "in #{row_incoming}"
        puts "ot #{row_outgoing}"
      
        table_index += 2
        i += 5
      }
      
      table[0].length.times{ |col|
        puts "col ||| #{col}"
        i = 1
        inside = false
        first_inside = true
        (table.length/2).times{ |row|
          row_ix = row * 2
          incoming = table[row_ix][col]
          outgoing = table[row_ix+1][col]
          # puts "in #{incoming}"
          # puts "out #{outgoing}"
          if incoming != 0
            inside = false
            first_inside = true
          end
          if outgoing != 0
            inside = true
          end
          # break if i+4 > plot.length - 1
          if inside
            if first_inside
              # plot[i][ix] = " v "
              # plot[i+1][ix] = " v "
              # plot[i+2][ix] = " v "
              plot[i+3][col] = " v "
              plot[i+4][col] = " v "
              first_inside = false
            else
              5.times{|r|
                if plot[i+r][col] == "   "
                  plot[i+r][col] = " v "
                elsif plot[i+r][col] == ">>>"
                  plot[i+r][col] = ">+>"
                elsif plot[i+r][col] == "<<<"
                  plot[i+r][col] = "<+<"
                end
              }  
            end
          end
          # puts " #{plot[i][col]}"
          # puts " #{plot[i+1][col]}"
          # puts " #{plot[i+2][col]}"
          # puts " #{plot[i+3][col]}"
          # puts " #{plot[i+4][col]}"
          # puts "col"
          # gets
          i += 5
        }
      }

      # puts "PLOT"
      # plot.each{ |r|
      #   puts r.join
      # }

      p edges2
      p nodes
      p endnode

      # i = 7
      # n1 = nil
      # n2 = nil
      # pl = plot.length

      # while i+5 < pl do
      #   puts "Testing nodes, i = #{i}"
      #   j = plot[i].index{|x| x.class == Integer}
      #   above = plot[i-2][j]
      #   below = plot[i+2][j]
      #   above_corner = plot[i-1][j+1]
      #   below_corner = plot[i+1][j+1]
      
      #   p above
      #   p below
      #   p above_corner
      #   p below_corner
      
      #   if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
      #     p "Found first node"
      #     n1 = [i,j]
      #   end
      
      #   if n1
      #     s = i + 5
      #     t = plot[s].index{|x| x.class == Integer}
      #     above = plot[s-2][t]
      #     below = plot[s+2][t]
      #     above_corner = plot[s-1][t+1]
      #     below_corner = plot[s+1][t+1]
        
      #     if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
      #       p "Found second node"
      #       n2 = [s,t]
      #     else
      #       n2 = nil
      #     end

      #     puts "n1"
      #     p n1
      #     puts "n2"
      #     p n2
      
      #     if n1 && n2
      #       p "Check if nodes are compatible for sliding"
      #       r1 = n1[0]
      #       c1 = n1[1]
      
      #       r2 = n2[0]
      #       c2 = n2[1]
      
      #       compare_row1_1 = plot[r1-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      #       compare_row1_2 = plot[r1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      #       compare_row1_3 = plot[r1+1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      
      #       compare_row2_1 = plot[r2-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      #       compare_row2_2 = plot[r2].map{|x| x == "---" || x.class == Integer ? " v " : x}
      #       compare_row2_3 = plot[r2+1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      
      #       if compare_row1_1 == compare_row2_1 && compare_row1_2 == compare_row2_2 && compare_row1_3 == compare_row2_3
      
      #         p "Before"
      #         p plot[r1]
      #         p plot[r2]
        
      #         plot[r1][c2], plot[r2][c2] = plot[r2][c2], plot[r1][c2]
      #         plot[r1+1][c2], plot[r2+1][c2] = plot[r2+1][c2], plot[r1+1][c2]
      #         plot[r1-1][c2], plot[r2-1][c2] = plot[r2-1][c2], plot[r1-1][c2]
        
      #         p "After"
      #         p plot[r1]
      #         p plot[r2]
      
      #         plot.slice!(r1+2, 5)

      #         pl = plot.length

      #         # n2 = nil
      #         next
      #         # sliceis.each{|r|
      #         #   p r.join
      #         # }
      #         # Eliminate unnecesary column
      #       end
      
      #     end
      
      #   end
      #   pl = plot.length
      
      #   i += 5
      # end







      def collision(r1, r2)
        if r1.length != r2.length
          nil
        end
        r1.zip(r2).each{ |c1, c2| 
          if c1 == "<<<" || c1 == "<< " || c1 == "<+<" || c1 == "---" || c1 == "<v<"
            if c2 == ">>>" || c2 == ">> " || c2 == ">+>" || c2 == "---" || c2 == ">v>" || c2 == "<<<" || c2 == "<< " || c2 == "<+<" || c2 == "---" || c2 == "<v<"
              puts "c1 #{c1} c2 #{c2}"
              return true
            end
          end
        }
        return false
      end
      
      i = 7
      
      while i < plot.length 
        j = i - 1
        k = j - 3
        puts "Node #{plot[i].select{|x| x.class == Integer}}"
        until collision(plot[j], plot[k])
          k -= 1
        end
        puts "Shift to #{k}"
      
        node_col = plot[i].index{|x| x.class == Integer}
      
        rowstodelete = j - k
        k += 3
      
        if k < i-1
          puts "DO SHIFT!"
          # Destination
      
          m1 = node_col
          while plot[i-1][m1] == "<v<" || plot[i-1][m1] == "<< " || plot[i-1][m1] == "---" || plot[i-1][m1] == "<+<" || plot[i-1][m1] == "   " || plot[i-1][m1] == "<<<" 
            plot[k][m1] = plot[i-1][m1]
            plot[k+1][m1] = plot[i][m1]
            m1 += 1
          end
      
          m2 = node_col
          while plot[i+1][m2] == ">v>" || plot[i+1][m2] == ">> " || plot[i+1][m2] == "---" || plot[i+1][m2] == ">+>" || plot[i+1][m2] == "   " || plot[i+1][m2] == ">>>" || m2 < m1
            plot[k+1][m2] = plot[i][m2]
            plot[k+2][m2] = plot[i+1][m2]
            (k+3..i+1).each{ |ix|
              # puts "is #{ix}"
              # puts "plot ix m #{plot[ix][m]}"
              plot[ix][m2] = plot[i+2][m2]
            }
            m2 += 1
          end
      
      
          # plot[k] = plot[k][0...node_col] + plot[i-1][node_col..-1]
          # plot[k+1] = plot[k+1][0...node_col] + plot[i][node_col..-1]
          # plot[k+2] = plot[k+2][0...node_col] + plot[i+1][node_col..-1]
      
          # plot.delete_at(i)
          until plot[k+6].any?{|x| x.class == Integer}
            # puts "DELETE xxxxxxx"
            plot.delete_at(k+5)
          end
      
          i = k+6
          # gets
          # break
          # 5.times{plot.delete_at(i-1)}
        else
          # puts "DONT SHIFT"
          i += 1
          until plot[i].any?{|x| x.class == Integer}
            i += 1
            if i > plot.length - 1
              break
            end  
          end
          i+=5
        end
      
        # puts "COMPRESSED PLOT STEP"
        # plot.each{ |r|
        #   puts r.join
        # }
      end

      @grid = plot.transpose
      @root_n = Node.find_by(id: endnode)

      ###
      #
      # Optimize later: load all nodes before rendering on page.

      # table.each{|r|
      #   r.map!{|c|
      #     if c.class == Integer
      #       Node.find_by(id: c)
      #     end
      #   }
      # }

      # puts "PLOTe"
      # plot.each{ |r|
      #   puts r.join
      # }
      # levels.each{ |lv| 
      #   @rows.push(Node.where("id IN (#{lv.join(',')})").includes(:from_nodes))
      # }

    end
  end

  # GET /projects/new
  def new
    @project = Project.new(project_params)
    # if current_user
    #   @project.user_id = current_user.id
    # end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        @project.nodes.first.update(name: @project.name)
        @project.nodes.first.update(description: @project.description)
        # Node.create(name: @project.name, description: @project.description, project_id: @project.id)
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description, :user_id, nodes_attributes: [:name])
    end
end
