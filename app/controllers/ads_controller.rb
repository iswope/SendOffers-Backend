require 'net/http'
require 'net/https'
require 'rexml/document'

class AdsController < ApplicationController
  
  before_filter :authenticate
    
  def get_lists_api
    @uuid = params[:uuid]
    @report = params[:report]
    @created = params[:created]
    @mailing = params[:mailing]
    @group = params[:group]
    @name = params[:name]
    @subject = params[:subject]
    #@client = Client.find(:first, :conditions => ['uuid = ?', @uuid])
    
      
    #@report = "Mailings"
    #@report = "Groups"
    #@report = "Contacts"
    
    #@report = "Content"
    #@report = "Mailing"
    #@report = "Content"

    
    accountid = '6a41fce9-8dbd-4464-a07b-7c87ed0001c6'
    
    case @report
      when "Groups"
        method = "get"
        service_url= '/Rest/Content/Mailings/v1/groups/' + accountid
      when "Contacts"
        method = "post"
        service_url= '/Rest/Contacts/v1/lists/query/' + accountid
        filter = '<ListFilter></ListFilter>'
      when "Mailings"
        a = @created.split("T")
        create_date =  a[0].to_s
        method = "post"
        service_url= '/Rest/Reports/v1/mailings/query/' + accountid 
        #filter = "<MailingReportFilter><MaxResults>20</MaxResults><ScheduledDeliveryOnOrAfter>2012-11-26T12:00:47</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>2012-12-03T12:00:47</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
        #filter = "<MailingReportFilter><MaxResults>30</MaxResults><ScheduledDeliveryOnOrAfter>" + @created + "</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>" + @created + "</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
        filter = "<MailingReportFilter><MaxResults>30</MaxResults><ScheduledDeliveryOnOrAfter>" + create_date + "T00:00:00" + "</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>" + create_date + "T23:59:59" + "</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
      when "byGroup"
        method = "post"
        service_url= '/Rest/Content/Mailings/v1/query/' + accountid
        #filter = "<MailingFilter><GroupId>" + @group + "</GroupId><MaxResults>20</MaxResults><ScheduledDeliveryOnOrAfter>2012-11-25T12:00:47</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>2012-11-28T12:00:47</ScheduledDeliveryOnOrBefore></MailingFilter>"
        filter = "<MailingFilter><GroupId>" + @group + "</GroupId></MailingFilter>"
      when "Content"
        method = "get"
        service_url= '/Rest/Content/Mailings/v1/' + accountid
      when "Mailing"
        
        method = "post"
        service_url= '/Rest/Reports/v1/mailings/query/' + accountid
        filter = "<MailingReportFilter><MailingId>" + @mailing + "</MailingId></MailingReportFilter>"
        
=begin
        method = "get"
        #service_url= '/Rest/Reports/v1/mailings/' + accountid + "/" + @mailing
        service_url= '/Rest/Content/Mailings/v1/' + accountid + "/" + @mailing
=end
      when "Stats"
        method = "get"
        service_url= '/Rest/Reports/v1/mailings/' + accountid + "/" + @mailing
        #service_url= '/Rest/Content/Mailings/v1/' + accountid + "/" + @mailing
      else
        @report = "Groups"
        method = "get"
        service_url= '/Rest/Content/Mailings/v1/groups/' + accountid
    end
=begin    
    http = Net::HTTP.new('services.reachmail.net',443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    if method == 'get'
      req = Net::HTTP::Get.new(service_url)
      req.basic_auth 'SENDOFFE\admin', 'Obl1skc3p0!'
      #req["Content-Type"] = "text/xml"
      #req["Content-Length"] = "1020"
      resp = http.request(req)
    elsif method == 'post'
      req = Net::HTTP::Post.new(service_url)
      req.basic_auth 'SENDOFFE\admin', 'Obl1skc3p0!'
      req["Content-Type"] = "text/xml"
      resp = http.request(req, filter)
    end
=end    
   resp = getReports(method, service_url,filter)

   doc = REXML::Document.new(resp.body)

   @raw = resp.body
   @response = Array.new
   
   case @report
      when "Groups"
        doc.elements.each("Groups/Group") { |element| 
          @response << "GroupId: <a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => 1, :uuid => @uuid, :report => 'byGroup', :group => element.elements["Id"].get_text.to_s) + "'>" + element.elements["Id"].get_text.to_s + "</a>," + element.elements["Name"].get_text.to_s
        }
      when "Contacts"
        doc.elements.each("Lists/List") { |element| 
          @response << element.elements["CreateDate"].get_text.to_s + ", GroupId: " + element.elements["GroupId"].get_text.to_s + ", Id: " + element.elements["Id"].get_text.to_s + "," + element.elements["Name"].get_text.to_s
        }
      when "Mailings"
        doc.elements.each("MailingReports/MailingReport") { |element|
          if element.elements["Message/Name"].get_text.to_s == @name and element.elements["Message/Subject"].get_text.to_s == @subject
            @response << "Created: " + element.elements["Created"].get_text.to_s + "<br />MailingId: " + element.elements["MailingId"].get_text.to_s + "<br />Name : " + element.elements["Message/Name"].get_text.to_s + "<br />Subject: " + element.elements["Message/Subject"].get_text.to_s + "<br />"
            @response << "Sent: " + element.elements["Lists/MailingListReport/RecipientCount/Sent"].get_text.to_s + "<br />"
          end
        }
      when "byGroup"
        doc.elements.each("Mailings/Mailing") { |element|    
          #@response << element.elements["Created"].get_text.to_s + ", Id: <a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => @uuid, :report => 'Mailing', :mailing => element.elements["Id"].get_text.to_s) + "'>" + element.elements["Id"].get_text.to_s + "</a>, " + element.elements["Name"].get_text.to_s + ", " + element.elements["Subject"].get_text.to_s + "<br />"
          @response << "<a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => 1, :uuid => @uuid, :report => 'Mailings', :mailing => element.elements["Id"].get_text.to_s, :name => element.elements["Name"].get_text.to_s, :created => element.elements["Created"].get_text.to_s, :subject => element.elements["Subject"].get_text.to_s) + "'>" + element.elements["Created"].get_text.to_s + "</a>" + ", Id: " + element.elements["Id"].get_text.to_s + ", " + element.elements["Name"].get_text.to_s + ", " + element.elements["Subject"].get_text.to_s + "<br />"
        }
      when "Content"
        #doc.elements.each("Mailings/Mailing") { |element| 
          #@response << element.elements["Created"].get_text.to_s + ", Name " + element.elements["Name"].get_text.to_s + ", MailingId: " + element.elements["Id"].get_text.to_s
        #}
      when "Mailing"
          #text = doc.elements["MailingReport/Message/ContentHtml"].get_text.to_s 
          
          @aid = doc.elements["Mailing/Id"].get_text.to_s
          @addressid = doc.elements["Mailing/AddressId"].get_text.to_s
          
          text = "<a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => 1, :uuid => @uuid, :report => 'Stats', :mailing => doc.elements["Mailing/Id"].get_text.to_s) + "'>{" + doc.elements["Mailing/Id"].get_text.to_s + "}</a><br />" + doc.elements["Mailing/HtmlContent"].get_text.to_s
          @html = REXML::Text::unnormalize(text)
          
          #render :inline => @html
      when "Stats"
        doc.elements.each("MailingReport/Lists/MailingListReport") { |element|           
          #@response << element.elements["Created"].get_text.to_s + ", MailingListId: " + element.elements["Lists/MailingListReport/MailingListId"].get_text.to_s + ", MailingId: <a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => @uuid, :report => 'Stats', :mailing => element.elements["MailingId"].get_text.to_s) + "'>" + element.elements["MailingId"].get_text.to_s + "</a>, " + element.elements["Lists/MailingListReport/ListName"].get_text.to_s + ", " + element.elements["Lists/MailingListReport/RecipientCount/Sent"].get_text.to_s + "<br />"
          @response << "DeliveredDate: " + element.elements["DeliveredDate"].get_text.to_s + ", Active: " + element.elements["RecipientCount/Active:"].get_text.to_s + ", Bounce: " + element.elements["RecipientCount/Bounce:"].get_text.to_s + ", Sent " + element.elements["RecipientCount/Sent:"].get_text.to_s + ", MailingId: <a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => @uuid, :report => 'Mailing', :mailing => element.elements["MailingId"].get_text.to_s) + "'>" + element.elements["MailingId"].get_text.to_s + "</a>, "
           # + element.elements["Lists/MailingListReport/ListName"].get_text.to_s + ", " + element.elements["Lists/MailingListReport/RecipientCount/Sent"].get_text.to_s + "<br />"
        }
    end

    respond_to do |format|
      format.html 
      format.xml { render xml: @response }
    end
  end
  
  def getReports(method, service_url, filter)
    http = Net::HTTP.new('services.reachmail.net',443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    if method == 'get'
      req = Net::HTTP::Get.new(service_url)
      req.basic_auth 'SENDOFFE\admin', 'Obl1skc3p0!'
      #req["Content-Type"] = "text/xml"
      #req["Content-Length"] = "1020"
      resp = http.request(req)
    elsif method == 'post'
      req = Net::HTTP::Post.new(service_url)
      req.basic_auth 'SENDOFFE\admin', 'Obl1skc3p0!'
      req["Content-Type"] = "text/xml"
      resp = http.request(req, filter)
    end
  end
  
  def admin_dash
    #@uuid = params[:uuid]
    #@client = Client.find(:first, :conditions => ['uuid = ?', params[:uuid]])
    unless @client.role == 'Admin'
      flash[:notice] = "Admin Only!"
      redirect_to 'login'
    end
    @clients = Client.order('company ASC')
    @report = "Groups"
    method = "get"
    accountid = '6a41fce9-8dbd-4464-a07b-7c87ed0001c6'
    service_url= '/Rest/Content/Mailings/v1/groups/' + accountid
    resp = getReports(method, service_url,'')
    doc = REXML::Document.new(resp.body)
    @raw = resp.body
    
    
    @response = Array.new
    doc.elements.each("Groups/Group") { |element| 
      @response << "<a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => 1, :uuid => @uuid, :report => 'byGroup', :group => element.elements["Id"].get_text.to_s) + "'>" + element.elements["Name"].get_text.to_s + "</a>"
    }
    #@supplier_dirs = Dir.glob("../../suppliers/*")
    @dirs = Array.new
    Dir.foreach("../suppliers") do |fname|
      @checkAcct = Client.find(:first, :conditions => ['acct_name = ?', fname])
      unless File.file?(fname) or fname == "." or fname == ".."
        if @checkAcct.nil?
          @dirs << fname + "&nbsp;*"
        else
          @dirs << fname
        end
      end
      @dirs = @dirs.sort
    end
  end
  
  def supplier_dash
    @ads = nil
    accountid = '6a41fce9-8dbd-4464-a07b-7c87ed0001c6'
    @uuid = params[:uuid]
    @report = params[:report]
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:uuid]]) 
    @ads = Ad.find(:all, :conditions => ['client_id = ?', @client.id])
    @response = Array.new
    case @report
      when "Mailings"
        method = "post"
        @name = params[:name]
        @subject = params[:subject]
        @created = params["created"]
        a = @created.split("T")
        create_date =  a[0].to_s
        service_url= '/Rest/Reports/v1/mailings/query/' + accountid 
        filter = "<MailingReportFilter><MaxResults>30</MaxResults><ScheduledDeliveryOnOrAfter>" + create_date + "T00:00:00" + "</ScheduledDeliveryOnOrAfter><ScheduledDeliveryOnOrBefore>" + create_date + "T23:59:59" + "</ScheduledDeliveryOnOrBefore></MailingReportFilter>"
        resp = getReports(method, service_url,filter)
        doc = REXML::Document.new(resp.body)
        doc.elements.each("MailingReports/MailingReport") { |element|
          if element.elements["Message/Name"].get_text.to_s == @name and element.elements["Message/Subject"].get_text.to_s == @subject
            @response << "Created: " + element.elements["Created"].get_text.to_s + "<br />MailingId: " + element.elements["MailingId"].get_text.to_s + "<br />Name : " + element.elements["Message/Name"].get_text.to_s + "<br />Subject: " + element.elements["Message/Subject"].get_text.to_s + "<br />"
            @response << "<h3>Sent: " + element.elements["Lists/MailingListReport/RecipientCount/Sent"].get_text.to_s + " Expected: " + element.elements["Lists/MailingListReport/RecipientCount/Expected"].get_text.to_s + " HardBounce: " + element.elements["Lists/MailingListReport/RecipientCount/HardBounce"].get_text.to_s + " Expected: " + element.elements["Lists/MailingListReport/RecipientCount/Expected"].get_text.to_s + " Read: " + element.elements["Lists/MailingListReport/RecipientCount/Read"].get_text.to_s + " Received: " + element.elements["Lists/MailingListReport/RecipientCount/Received"].get_text.to_s + " Total: " + element.elements["Lists/MailingListReport/RecipientCount/Total"].get_text.to_s + "</h3><br />"
            text = element.elements["Message/ContentHtml"].get_text.to_s
            @html = REXML::Text::unnormalize(text)
          end
        }
      else
        method = "post"
        service_url= '/Rest/Content/Mailings/v1/query/' + accountid
        filter = "<MailingFilter><GroupId>" + @client["reachmailgroup_id"] + "</GroupId></MailingFilter>"
        resp = getReports(method, service_url,filter)
        doc = REXML::Document.new(resp.body)
        doc.elements.each("Mailings/Mailing") { |element|    
          #@response << element.elements["Created"].get_text.to_s + ", Id: <a href='" + url_for(:controller => 'ads', :action => 'get_lists_api', :id => @uuid, :report => 'Mailing', :mailing => element.elements["Id"].get_text.to_s) + "'>" + element.elements["Id"].get_text.to_s + "</a>, " + element.elements["Name"].get_text.to_s + ", " + element.elements["Subject"].get_text.to_s + "<br />"
          a = element.elements["Created"].get_text.to_s.split("T")
          create_date =  a[0].to_s
          @response << create_date + " " + "<a href='" + url_for(:controller => 'ads', :action => 'supplier_dash', :id => 1, :uuid => @uuid, :report => 'Mailings', :mailing => element.elements["Id"].get_text.to_s, :name => element.elements["Name"].get_text.to_s, :created => element.elements["Created"].get_text.to_s, :subject => element.elements["Subject"].get_text.to_s) + "'>" + element.elements["Name"].get_text.to_s + "</a>" + "<br />"
        }
    end

    respond_to do |format|
      format.html # supplier.html.erb
      format.json { render json: @ads }
    end
  end
  
  def 
  
  def supplier_ad
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:uuid]])
    @ad = Ad.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ad }
    end
  end
  
  def supplier_create
    @client = Client.find(:first, :conditions => ['uuid = ?', params[:uuid]])
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

      format.html { redirect_to :action => :supplier_dash, :id => 1, :uuid => @client.uuid }
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
      format.html { render :action => :admin_dash, :id => 1, :uuid => @uuid }
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
  end
end


