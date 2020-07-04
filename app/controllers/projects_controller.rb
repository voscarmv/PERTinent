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
      
      table = Array.new(nodes.length){Array.new(1,0)}
      
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
      
        puts "#{startnode},#{endnode}"
        x = table[nest1s - 1].index {|c| c != 0}
        unless x
          x = 0
        end
        cols = table.transpose
      
        found = false
        while x < cols.length do
          puts "colx"
          p cols[x]
          cols[x].delete_at(nest1e-1)
          cols[x].shift(nest1s)
          if cols[x].all?(0)
            table[nest1s-1][x] = startnode
            table[nest1e-1][x] = endnode
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
            table[nest1e-1][x] = endnode
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
        p r
      }
      
      plot = Array.new()
      
      plot.push(Array.new(table[0].length,"   "))
      i = 1
      cols = table.transpose
      table.each_with_index{ |r, k|
        5.times{
          plot.push(Array.new(r.length,"   "))
        }
        e = r.index { |c| c != 0 }
        plot[i][e] = "---"
        plot[i+1][e] = r[e]
        plot[i+2][e] = "---"
        lf = false
        rf = false
        l1 = true
        r1 = true
        r.reverse.each_with_index{ |v, j|
          ix = r.length - 1 - j
          if v != 0
            colcpy = cols[ix].dup
            colcpy.shift(k+1)
            puts "val #{v}"
            puts "col #{colcpy}"
            puts "col shift #{colcpy}"
            puts "col shift index #{colcpy.index {|c| c != 0}}"
            below = colcpy.index {|c| c != 0}
            if below
              plot[i+3][ix] = " v "
              plot[i+4][ix] = " v "
            end
            if ix != e
              # puts "plot[i-1][ix] #{plot[i-1][ix]}"
              if plot[i-1][ix] == " v "
                lf = true
              end
              if below
                rf = true
                plot[i+3][ix] = " v "
                plot[i+4][ix] = " v "
              end 
            else
              if lf
                lf = false
              end
              if rf
                rf = false
              end
            end
          end
          if ix != e
            if plot[i-1][ix] == " v "
              if !lf && !rf
                plot[i][ix] = " v "
                plot[i+1][ix] = " v "
                plot[i+2][ix] = " v "
                plot[i+3][ix] = " v "
                plot[i+4][ix] = " v "
              end
              if !lf && rf
                plot[i][ix] = " v "
                plot[i+1][ix] = " v "
                plot[i+2][ix] = ">+>"
                plot[i+3][ix] = " v "
                plot[i+4][ix] = " v "
              end
              if lf && !rf
                if v != 0
                  if l1
                    plot[i][ix] = "<< "
                    l1 = false
                  else
                    plot[i][ix] = "<v<"
                  end  
                else
                  plot[i][ix] = "<+<"
                  plot[i+1][ix] = " v "
                  plot[i+2][ix] = " v "
                  plot[i+3][ix] = " v "
                  plot[i+4][ix] = " v "
                end
              end
              if lf && rf
                if l1
                  plot[i][ix] = "<< "
                  l1 = false
                else
                  plot[i][ix] = "<v<"
                end
                if r1
                  plot[i+2][ix] = ">> "
                  r1 = false
                else
                  if below
                    plot[i+2][ix] = ">v>"
                  else
                    plot[i+2][ix] = ">>>"
                  end
                end
              end
            else
              if !lf && rf
                if r1
                  plot[i+2][ix] = ">> "
                  r1 = false
                else
                  if below
                    plot[i+2][ix] = ">v>"
                  else
                    plot[i+2][ix] = ">>>"
                  end
                end
              end
              if lf && !rf
                if l1
                  plot[i][ix] = "<< "
                  l1 = false
                else
                  plot[i][ix] = "<<<"
                end
              end
              if lf && rf
                if l1
                  plot[i][ix] = "<< "
                  l1 = false
                else
                  plot[i][ix] = "<<<"
                end
                if r1
                  plot[i+2][ix] = ">> "
                  r1 = false
                else
                  if below
                    plot[i+2][ix] = ">v>"
                  else
                    plot[i+2][ix] = ">>>"
                  end
                end
              end
            end
          end
        }
        puts "this"
        p plot[i-1]
        i+=5
      }
      
      # puts "PLOT"
      # plot.each{ |r|
      #   puts r.join
      # }

      p edges2
      p nodes
      p endnode

      i = 7
      n1 = nil
      n2 = nil
      pl = plot.length

      while i+5 < plot.length do
        puts "Testing nodes"
        j = plot[i].index{|x| x.class == Integer}
        above = plot[i-2][j]
        below = plot[i+2][j]
        above_corner = plot[i-1][j+1]
        below_corner = plot[i+1][j+1]
      
        p above
        p below
        p above_corner
        p below_corner
      
        if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
          p "Found first node"
          n1 = [i,j]
        end
      
        if n1
          s = i + 5
          t = plot[s].index{|x| x.class == Integer}
          above = plot[s-2][t]
          below = plot[s+2][t]
          above_corner = plot[s-1][t+1]
          below_corner = plot[s+1][t+1]
        
          if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
            p "Found second node"
            n2 = [s,t]
          end
      
          if n1 && n2
            p "Check if nodes are compatible for sliding"
            r1 = n1[0]
            c1 = n1[1]
      
            r2 = n2[0]
            c2 = n2[1]
      
            compare_row1_1 = plot[r1-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
            compare_row1_2 = plot[r1].map{|x| x == "---" || x.class == Integer ? " v " : x}
            compare_row1_3 = plot[r1+1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      
            compare_row2_1 = plot[r2-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
            compare_row2_2 = plot[r2].map{|x| x == "---" || x.class == Integer ? " v " : x}
            compare_row2_3 = plot[r2+1].map{|x| x == "---" || x.class == Integer ? " v " : x}
      
            if compare_row1_1 == compare_row2_1 && compare_row1_2 == compare_row2_2 && compare_row1_3 == compare_row2_3
      
              p "Before"
              p plot[r1]
              p plot[r2]
        
              plot[r1][c2], plot[r2][c2] = plot[r2][c2], plot[r1][c2]
              plot[r1+1][c2], plot[r2+1][c2] = plot[r2+1][c2], plot[r1+1][c2]
              plot[r1-1][c2], plot[r2-1][c2] = plot[r2-1][c2], plot[r1-1][c2]
        
              p "After"
              p plot[r1]
              p plot[r2]
      
              plot.slice!(r1+2, 5)

              next
              # sliceis.each{|r|
              #   p r.join
              # }
              # Eliminate unnecesary column
            end
      
          end
      
        end
      
        i += 5
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
