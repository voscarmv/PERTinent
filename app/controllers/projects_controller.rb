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

      links = Link.where(project_id: prjid).pluck("from_id, to_id")
      @edges = links.clone
      # p links
      nodes = Node.where(project_id: prjid).pluck("id")
      # root = 0
      # nodes.push(root)
      @vertices = nodes.clone
      # p nodes

      levels = []
      root = Node.where(project_id: prjid).order(:created_at).limit(1).first.id
      row = [root]
      levels.push(row)

      @rows = []
      unless nodes.count > 1 
        levels.each{ |lv| 
          @rows.push(Node.where("id IN (#{lv.join(',')})"))
        }
        return
      end

      nodes = nodes.reject{|node| row.include?(node) }  
      
      while nodes.length > 0 do
        row2 =
          links.select { |edge| row.include?(edge[1]) }
          .map { |x| x[0] }
          .uniq.select{|node| nodes
          .include?(node)}
        levels.push(row2)
        puts "row2 #{row2}"
        links = links.reject{ |edge| row.include?(edge[1]) }
        puts "links #{links}"
        nodes = nodes.reject{ |node| row2.include?(node) }  
        puts "nodes #{nodes}"
        row = row2
      end

      # p levels

      levels.each{ |lv| 
        @rows.push(Node.where("id IN (#{lv.join(',')})"))
      }

    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    if current_user
      @project.user_id = current_user.id
    end
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
        Node.create(name: @project.name, description: @project.description, project_id: @project.id)
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
      params.require(:project).permit(:name, :description, :user_id)
    end
end
