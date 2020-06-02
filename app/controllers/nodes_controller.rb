class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new(node_params)

    # if link_params
    #   if link_params[:parent_node]
    #     session[:parent_node] = link_params[:parent_node]
    #   end  
    # end
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        # if session[:parent_node]
        #   @link = Link.new(from_node: @node, to_node: Node.where(id: session[:parent_node]).first, project_id: node_params[:project_id])
        #   @link.save
        #   session[:parent_node] = nil
        # end
        format.html { redirect_to project_path(Project.where(id: @node.project_id).first, anchor: "n_#{@node.id}"), notice: 'Node was successfully created.' }
        # format.html { redirect_to projects_url, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        parent_project = @node.project
        format.html { redirect_to project_path(parent_project, anchor: "n_#{@node.id}"), notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    parent_project = @node.project
    parent_node = @node.to_nodes.first
    @node.destroy
    respond_to do |format|
      format.html { redirect_to project_path(parent_project, anchor: "n_#{parent_node.id}"), notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def node_params
      params.require(:node).permit(:name, :description, :project_id, :complete, to_links_attributes: [:to_id, :project_id])
    end

    # def link_params
    #   params.require(:link).permit(:parent_node)
    # end
end
