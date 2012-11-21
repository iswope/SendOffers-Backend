require 'net/http'
require 'net/https'
require 'rexml/document'

class AdsController < ApplicationController
  
    
  def get_lists_api
    #report = params[:report]
    #@client = Client.find(:first, :conditions => ['uuid = ?', params[:id]])
    
    report = "mailings"
    
    case report
      when "contacts"
        service_url= '/Rest/Contacts/v1/lists/query/'
        filter = '<ListFilter></ListFilter>'
      when "mailings"
        service_url= '/Rest/Reports/v1/mailings/query/'
        filter = "<MailingReportFilter><MaxResults>10</MaxResults><ScheduledDeliveryOnOrAfter>2012-11-10T12:00:47</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>2012-11-19T12:00:47</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
      when "content"
        service_url= '/Rest/Content/Mailings/v1/query/'
        filter = '<MailingFilter><MaxResults>10</MaxResults></MailingFilter>'
      when "mailing"
        service_url= '/Rest/Reports/v1/mailings/'
        filter = '<MailingReport></MailingReport>'
    end
    
    accountid = '6a41fce9-8dbd-4464-a07b-7c87ed0001c6'
    http = Net::HTTP.new('services.reachmail.net',443)
    req = Net::HTTP::Post.new(service_url + accountid)
    #filter = "<MailingReportFilter><MaxResults>10</MaxResults><ScheduledDeliveryOnOrAfter>2012-11-01T12:00:47</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>2012-11-19T12:00:47</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
    
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req.basic_auth 'SENDOFFE\admin', 'Obl1skc3p0!'
    req["Content-Type"] = "text/xml"
    resp = http.request(req, filter)
    #@response = resp.body # debug
    doc = REXML::Document.new(resp.body)
 
   @response = Array.new
   
   case report
      when "contacts"
        doc.elements.each("Lists/List") { |element| 
          @response << element.elements["CreateDate"].get_text.to_s + "," + element.elements["Name"].get_text.to_s
        }
      when "mailings"
        doc.elements.each("MailingReports/MailingReport") { |element| 
          @response << element.elements["Created"].get_text.to_s + ", " + element.elements["MailingId"].get_text.to_s + ", " + element.elements["Lists/MailingListReport/ListName"].get_text.to_s
        }
      when "content"
        
      when "mailing"
        
    end
   
   
   
   
=begin    
    doc.elements.each("Lists/List") { |element| 
    #doc.elements.each("MailingReports/MailingReport") { |element| 
        #element.attributes.each {|name, value| @response <<  "{" + value.gsub(/\s/, '') + " => '" + element.get_text.to_s + "'}" }
        #element.attributes.each {|name, value| @response <<  element.get_text.to_s }
        #element.attributes.each {|name, value| hxml[ element.get_text.to_s ] }
        #@response << element.elements["Field"].elements["Name"].text unless element.elements["Field"].elements["Name"].nil?
        #@response << element.elements["Fields"].elements["Name"].text
        
        #@response << element.elements["Created"].get_text.to_s + ", " + element.elements["MailingId"].get_text.to_s + ", " + element.elements["Lists/MailingListReport/ListName"].get_text.to_s
        @response << element.elements["CreateDate"].get_text.to_s + "," + element.elements["Name"].get_text.to_s
      }
=end    

    
 
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render xml: @response }
    end
  end
  
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
      f = File.new(fdir,  "r")
      fn = File.basename(f)
      dir = "#{Rails.root}/public/art/"
      new_fn = adid + "-d" + renameArt[:dist_art]
      new_fdir = dir + new_fn
      File.rename(fdir, new_fdir)

      tfdir = "#{Rails.root}/public/art/" + "thumb_" + adid + renameArt[:dist_art]
      tf = File.open(tfdir,  "r")
      tfn = File.basename(tf)
      dir = "#{Rails.root}/public/art/"
      pos = tfn.index("-")
      tnew_fn = tfn.insert(pos + 1, 'd-')
      tnew_fn = tnew_fn.gsub(/[--]/, '-') 
      tnew_fdir = dir + tnew_fn
      File.rename(tfdir, tnew_fdir)
     
      renameArt[:dist_art] = new_fn
      renameArt.save!
    end
    if params[:ad][:supp_art]
      fdir = "#{Rails.root}/public/art/" + renameArt[:supp_art]
      f = File.open(fdir,  "r")
      fn = File.basename(f)
      dir = "#{Rails.root}/public/art/"
      new_fn = adid + "-e" + renameArt[:supp_art]
      new_fdir = dir + new_fn
      File.rename(fdir, new_fdir)
      
      tfdir = "#{Rails.root}/public/art/" + "thumb_" + adid + renameArt[:supp_art]
      tf = File.open(tfdir,  "r")
      tfn = File.basename(tf)
      dir = "#{Rails.root}/public/art/"
      pos = tfn.index("-")
      tnew_fn = tfn.insert(pos + 1, 'e-')
      tnew_fn = tnew_fn.gsub(/[--]/, '-') 
      tnew_fdir = dir + tnew_fn
      File.rename(tfdir, tnew_fdir)
          
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
