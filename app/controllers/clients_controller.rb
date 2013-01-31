class ClientsController < ApplicationController
    
  before_filter :authenticate
  
  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    @uuid = params[:uuid]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])
    @uuid = params[:uuid]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    @uuid = params[:uuid]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @uuid = params[:uuid]
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])
    @uuid = params[:uuid]
    respond_to do |format|
      if @client.save
        format.html { redirect_to :controller => 'ads', :action => 'admin_dash', :id => 1, :uuid => @uuid, notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])
    @uuid = params[:uuid]
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to :controller => 'ads', :action => 'admin_dash', :id => 1, :uuid => @uuid, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    @uuid = params[:uuid]
    respond_to do |format|
      format.html { redirect_to :controller => 'ads', :action => 'admin_dash', :id => 1, :uuid => @uuid }
      format.json { head :no_content }
    end
  end
  
  protected
  def authenticate
    @uuid = params[:uuid]
    @client = Client.find(:first, :conditions => ['uuid = ?', @uuid])
    unless @client.nil?
      @role = @client.role
    else
      session['referer'] = request.env["HTTP_REFERER"]
      flash[:notice] = "Access Credentials issue, please login again.."
      redirect_to 'login'
    end
    unless @client.role == 'Admin'
      session['referer'] = request.env["HTTP_REFERER"]
      flash[:notice] = "Admin Only!"
      redirect_to 'login'
    end
  end
end
