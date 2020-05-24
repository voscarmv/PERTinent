class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.includes(:from_node).includes(:to_node).all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new(link_params)

    if current_user
      prjid = link_params[:project_id]

      links = Link.where(project_id: prjid).pluck("from_id, to_id")
      @edges = links.clone
      # p links
      nodes = Node.where(project_id: prjid).pluck("id")
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
        links = links.reject{ |edge| row.include?(edge[1]) }
        nodes = nodes.reject{ |node| row2.include?(node) }  
        row = row2
      end

      # p levels

      levels.each{ |lv| 
        @rows.push(Node.where("id IN (#{lv.join(',')})"))
      }

    end
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to Project.where(id: @link.project_id).first, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    parent_project = @link.from_node.project
    @link.destroy
    respond_to do |format|
      format.html { redirect_to parent_project, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:from_id, :to_id, :project_id)
    end
end
