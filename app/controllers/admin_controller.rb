class AdminController < ApplicationController

  def login
    if request.post?
      flash[:notice] = ''
      user = User.authenticate(params[:username], params[:password])
      if user
        role = user.role
        @client = Client.find(:first, :conditions => ['user_id = ?', user.id])
        session[:user_id] = user.id
        session[:role] = user.role
        session[:client_id] = @client.id
        session[:client_uuid] = @client.uuid
        session[:email] = @client.email
        session[:firstname] = @client.firstname
        session[:lastname] = @client.lastname
        session[:company] = @client.company
        unless session[:referer].nil? or session[:referer] == ''
          #flash[:notice] = "refered:" + session[:referer]#debug
          redirect_to(session[:referer], :client_id => @client.id.to_s, :email => @client.email)
        else
          flash[:notice] = role#debug
          case role
            when 'Unknown'
              redirect_to :action => :reset_role, :id => user.id
            when 'Admin'
                redirect_to :controller => :ads, :action => :admin_dash, :id => 1, :uuid => @client.uuid
            else
              sendto(role,@client.uuid)
          end
        end
      else
        flash[:notice] = "Invalid user/password combination"
        redirect_to(:action => "login")
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:role] = nil
    session[:referer] = nil
    session[:client_id] = nil
    session[:client_uuid] = nil
    session[:email] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  #renders new user page
  def register
    @user = User.new
    @newclient = Client.new
  end
  
  def setuser
    #@clients = Client.all
    #@clients.each do |client|
      
    #end
    
  end
  
  def savereg
    @client = Client.new(params[:client])
    @user = User.new()
    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.sopass = params[:user][:password]
    @user.role = params[:role]
    @role = params[:role]
    
    @client.uuid = UUIDTools::UUID.timestamp_create.to_s
    @client.role = params[:role]
    @client.status = "Pending"
    
    #unless params[:mailing_options].nil?
      #@client.mailing_options = params[:mailing_options]['opts']
    #else
      #@client.mailing_options = 0
    #end

    @user.save!
    @client.user_id = @user.id
    @client.save!
    #@details = Hash.new
    #@details["to"] = @client.email
    #@details["client_id"] = @client.id
    #email = Emailer.create_optin(@details)
    #email.set_content_type("text/html")
    #Emailer.deliver(email)
    session[:referer] = ''
    session[:user_id] = @user.id
    session[:client_id] = @client.id
    session[:client_uuid] = @client.uuid
    session[:email] = @client.email
    session[:firstname] = @client.firstname
    session[:lastname] = @client.lastname
    session[:company] = @client.company
    session[:status] = @client.status
    session[:role] = @client.role
    
    redirect_to 'http://backend.sendoffers.com/thankyou.html'
  end
  
  # after client registration
  def thankyou
    #flash[:notice] = "An Email has been sent to: " + params[:email].to_s + " for account activation."
    respond_to do |format|
      format.html # thankyou.html.erb
      format.xml  { render :xml => @client }
    end
  end
  
    # renders page
  def reset_pass
  end
  
  def role_options
    @opts = params[:opts]
    if @opts == "Supplier"
      #render :partial => 'supplier_reg', :layout => false, :locals => {:client => @client}
      #render :partial => "supplier_reg", :object => @client
      render :partial => 'supplier_reg', :layout => false, :status => :created
    elsif @opts == "Distributor"
      render :partial => 'distributor_reg', :layout => false, :locals => {:client => @client}
      #render :partial => "distributor_reg", :object => @client
    end
  end
  
  # renders page
  def reset_role
    @uid = params[:id]
  end
  
  # posted from reset_role page
  def role_reset
    @user = User.find(params[:id])
    @role = params[:reset_role][:role]
    @user.attributes = {:role => @role}
    if @user.save
        flash[:notice] = "Your 'Role' has been changed to: " + @role
        client_id = Client.find_by_user_id(@user.id)
        sendto(@role, client_id)
    end
  end
  
  def sendto(role,client_uuid)
    case role
        when 'Distributor'
          unless Client.find_by_uuid(client_uuid).status == 'Active'
            redirect_to ('http://www.sendoffers.com/thankyou.html')
          else
            redirect_to ('http://www.sendoffers.com/marketplace/')
          end
        when 'Supplier'
          #@has_ad = Ad.find(:first, :conditions => ['client_id = ?', client_id])
          #unless @has_ad.nil?
            redirect_to :controller => :ads, :action => :supplier_dash, :id => 1, :uuid => client_uuid
          #else
            #@has_prod = Product.find(:first, :conditions => ['client_id = ?', client_id])
            #unless @has_prod.nil?
              #redirect_to :controller => :clicks, :action => :stats, :id => 0, :client_id => client_id
            #else
              #flash[:notice] = "Start by Designing a new Email Ad"
              #redirect_to ('http://www.sendoffers.com/')
            #end
          #end
        else
          redirect_to ('http://www.sendoffers.com')
     end
  end
  
  
  
end
