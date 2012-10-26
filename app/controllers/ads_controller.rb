class AdsController < ApplicationController
  
  
  
  def supplier_dash
    @ads = Ad.find(:all, :conditions => ['client_id = ?', params[:client_id]])
    @client_id = params[:client_id]
    respond_to do |format|
      format.html # supplier.html.erb
      format.json { render json: @ads }
    end
  end
  
  def supplier_ad
    @ad = Ad.new
    @client_id = params[:client_id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ad }
    end
  end
  
  def supplier_create
    @ad = Ad.new(params[:ad])

    respond_to do |format|
      @client_id = params[:client_id]
      if @ad.save
        format.html { redirect_to :action => :supplier_dash, :id => @client_id, notice: 'Ad was successfully created.' }
        format.json { render json: @ad, status: :created, location: @ad }
      else
        format.html { redirect_to :action => :supplier_new, :id => @client_id, notice: 'There was an Error - Ad not created.'}
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def supplier_edit
    @client_id = params[:client_id]
    @ad = Ad.find(params[:id])
  end
  
  
  
  # -----------------------------------------------------------------------
  
  # GET /ads
  # GET /ads.json
  def index
    @ads = Ad.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ads }
    end
  end

  # GET /ads/1
  # GET /ads/1.json
  def show
    @ad = Ad.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ad }
    end
  end

  # GET /ads/new
  # GET /ads/new.json
  def new
    @ad = Ad.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ad }
    end
  end

  # GET /ads/1/edit
  def edit
    @ad = Ad.find(params[:id])
  end

  # POST /ads
  # POST /ads.json
  def create
    @ad = Ad.new(params[:ad])

    respond_to do |format|
      if @ad.save
        format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
        format.json { render json: @ad, status: :created, location: @ad }
      else
        format.html { render action: "new" }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ads/1
  # PUT /ads/1.json
  def update
    @ad = Ad.find(params[:id])

    respond_to do |format|
      if @ad.update_attributes(params[:ad])
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @ad = Ad.find(params[:id])
    @ad.destroy

    respond_to do |format|
      format.html { redirect_to ads_url }
      format.json { head :no_content }
    end
  end
end
