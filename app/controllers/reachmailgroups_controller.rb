class ReachmailgroupsController < ApplicationController
  # GET /reachmailgroups
  # GET /reachmailgroups.json
  def index
    @reachmailgroups = Reachmailgroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reachmailgroups }
    end
  end

  # GET /reachmailgroups/1
  # GET /reachmailgroups/1.json
  def show
    @reachmailgroup = Reachmailgroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reachmailgroup }
    end
  end

  # GET /reachmailgroups/new
  # GET /reachmailgroups/new.json
  def new
    @reachmailgroup = Reachmailgroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reachmailgroup }
    end
  end

  # GET /reachmailgroups/1/edit
  def edit
    @reachmailgroup = Reachmailgroup.find(params[:id])
  end

  # POST /reachmailgroups
  # POST /reachmailgroups.json
  def create
    @reachmailgroup = Reachmailgroup.new(params[:reachmailgroup])

    respond_to do |format|
      if @reachmailgroup.save
        format.html { redirect_to @reachmailgroup, notice: 'Reachmailgroup was successfully created.' }
        format.json { render json: @reachmailgroup, status: :created, location: @reachmailgroup }
      else
        format.html { render action: "new" }
        format.json { render json: @reachmailgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reachmailgroups/1
  # PUT /reachmailgroups/1.json
  def update
    @reachmailgroup = Reachmailgroup.find(params[:id])

    respond_to do |format|
      if @reachmailgroup.update_attributes(params[:reachmailgroup])
        format.html { redirect_to @reachmailgroup, notice: 'Reachmailgroup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reachmailgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reachmailgroups/1
  # DELETE /reachmailgroups/1.json
  def destroy
    @reachmailgroup = Reachmailgroup.find(params[:id])
    @reachmailgroup.destroy

    respond_to do |format|
      format.html { redirect_to reachmailgroups_url }
      format.json { head :no_content }
    end
  end
end
