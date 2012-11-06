class AdsController < ApplicationController
  
  
  def supplier_dash
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:id]])
    @ads = Ad.find(:all, :conditions => ['client_id = ?', @client.id])
    respond_to do |format|
      format.html # supplier.html.erb
      format.json { render json: @ads }
    end
  end
  
  def supplier_ad
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:id]])
    @ad = Ad.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ad }
    end
  end
  
  def supplier_create
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:id]])
    @ad = Ad.new(params[:ad])
    @ad.client_id = @client.id
    @ad.uuid = UUIDTools::UUID.timestamp_create.to_s
    @ad.status = "New"
    
    @ad.save!
    adid = @ad.id.to_s

=begin    
    if params[:ad][:dist_art]
      #@dist_art = "dist"
      params[:ad][:dist_art].original_filename = "-d-" + params[:ad][:dist_art].original_filename
      dist_art = @ad.dist_art.to_s
    end 
    if params[:ad][:supp_art]
      #@supp_art = "supp"
      params[:ad][:supp_art].original_filename = "-e-" + params[:ad][:supp_art].original_filename
      supp_art = @ad.supp_art.to_s
    end
    


    if params[:ad][:dist_art]
      uploader2 = ArtUploader.new
      uploader2.store!(params[:ad][:dist_art])
    end
    if params[:ad][:supp_art]
      uploader1 = ArtUploader.new
      uploader1.store!(params[:ad][:supp_art])
    end
=end
    
    renameArt = Ad.find(adid.to_i)
    
    if params[:ad][:dist_art]
      fdir = "#{Rails.root}/public/art/" + renameArt[:dist_art]
      f = File.new(fdir,  "w")
      fn = File.basename(f)
      dir = "#{Rails.root}/public/art/"
      new_fn = adid + "-d-" + renameArt[:dist_art]
      new_fdir = dir + new_fn
      File.rename(fdir, new_fdir)
      
      renameArt[:dist_art] = new_fn
      renameArt.save!
    end
    if params[:ad][:supp_art]
      fdir = "#{Rails.root}/public/art/" + renameArt[:supp_art]
      f = File.new(fdir,  "w")
      fn = File.basename(f)
      dir = "#{Rails.root}/public/art/"
      new_fn = adid + "-e-" + renameArt[:supp_art]
      new_fdir = dir + new_fn
      File.rename(fdir, new_fdir)
      
      renameArt[:supp_art] = new_fn
      renameArt.save!
    end

    respond_to do |format|

      format.html { redirect_to :action => :supplier_dash, :id => @client.uuid }
      format.json { render json: @ad, status: :created, location: @ad }
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
