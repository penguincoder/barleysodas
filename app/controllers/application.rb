class ApplicationController < ActionController::Base
  session :session_key => '_barleysodas_session_id'
  
  append_before_filter :block_prefetching_links
  append_before_filter :authorized?
  append_before_filter :set_current_people_id
  
  helper_method :logged_in?, :has_permission_for_action?
  
  cattr_accessor :current_people_id
  
  ##
  # Ensures that the request was made using an Ajax request.
  #
  def ensure_xhr
    return false unless request.xhr?
    true
  end
  
  ##
  # Determines if the user is logged in.
  #
  def logged_in?
    return !session[:people_title].nil?
  end
  
  ##
  # Determines if a user can access an action.
  #
  def authorized?
    return true if has_permission_for_action?
    respond_to do |format|
      format.html {
        if !logged_in?
          session[:request_url] = request.request_uri
          redirect_to new_session_path
          return
        end
        @content_title = 'Forbidden'
        @secondary_title = ''
        @hide_sidebar = true
        session[:request_url] = nil if !logged_in?
        render :template => 'shared/unauthorized'
      }
      format.xml { render :nothing => true, :status => 403 }
    end
  end
  
  ##
  # Sane error and missing document messages.
  #
  def rescue_action_in_public(exception)
    logger.debug("#{exception.class.name}: #{exception.to_s}")
    exception.backtrace.each { |bt| logger.debug "! #{bt}" }
    case exception
      when ::ActiveRecord::RecordNotFound,
           ::ActionController::UnknownController,
           ::ActionController::UnknownAction,
           ::ActionController::RoutingError
        render :file => File.join(RAILS_ROOT, 'public/404.html'),
          :status => '404 Not Found'
      else
        render :file => File.join(RAILS_ROOT, 'public/500.html'),
          :status => '500 Error'
    end
  end
  
  ##
  # Sets the +@page+ variable to allow discussions. This should probably
  # have some kind of permission availability check later on.
  #
  def allow_page_discussions
    @page.allow_discussions = true
  end
  
  protected
  
  ##
  # Finds an object model for the particular resource requested. This will be
  # used to find any model in the current pattern and maybe even the associated
  # Page model.
  #
  def fetch_model
    # where
    obj_type = params[:controller]
    # what
    tfu = Page.title_from_url(params[:id])
    
    # conditions for find
    cond_ary = [
      'title = :model_title'
    ]
    cond_var = {
      :model_title => tfu,
      :help_owner_type => 'Help'
    }
    # specific overrides for help, this has an owner type but it is just a Page
    if obj_type == 'help'
      cond_ary << 'owner_type = :help_owner_type'
      obj_type = 'pages'
    elsif obj_type == 'pages'
      cond_ary << 'owner_type IS NULL'
    end
    # the eventual name of the instance variable, like +@page+
    obj_name = obj_type.singularize
    
    # find the object
    obj = Class.class_eval(obj_name.camelize).find(:first,
      :conditions => [ cond_ary.join(' AND '), cond_var ])
    
    # allow the chance to make a new one if you GET the URL, but not for Style
    if request.get? and obj.nil? and obj_type != 'styles'
      flash[:notice] =
        "The #{obj_name} was not found, would you like to make it?"
      redirect_to :action => 'new', :new_title => tfu
      return
    elsif obj.nil?
      # fail if not found
      raise ActiveRecord::RecordNotFound.new
    end
    # set the class variable
    instance_variable_set("@#{obj_name}", obj)
    # set the associated page if necessary
    @page = obj.page if obj.respond_to?('page')
    true
  end
  
  private
  
  ##
  # Stops all prefetching by the Google web accelerator by returning a 403
  # forbidden error.
  #
  # Original Copyright:
  # Copyright (c) 2005 David Heinemeier Hansson
  #
  # Permission is hereby granted, free of charge, to any person obtaining
  # a copy of this software and associated documentation files (the
  # "Software"), to deal in the Software without restriction, including
  # without limitation the rights to use, copy, modify, merge, publish,
  # distribute, sublicense, and/or sell copies of the Software, and to
  # permit persons to whom the Software is furnished to do so, subject to
  # the following conditions:
  #
  # The above copyright notice and this permission notice shall be
  # included in all copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  # OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  # WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  #
  def block_prefetching_links
    if request.env["HTTP_X_MOZ"] == "prefetch"
      render :nothing => true, :status => "403 Forbidden"
      return false
    end
  end
  
  ##
  # Finds a People Permission models and determines if the People has access
  # to a particular aspect of the system. Also finds the Guest user and checks
  # for the Guest Role.
  #
  def has_permission_for_action?(aname = nil, cname = nil)
    role = nil
    aname ||= params[:action]
    cname ||= params[:controller]
    aname = aname.to_s
    cname = cname.to_s
    if logged_in?
      role = People.find(session[:people_id]).role rescue nil
    end
    role ||= Role.base_role
    while role
      return true if role.permissions.detect do |p|
        p.controller.to_s == cname and p.action.to_s == aname
      end
      role = role.parent
    end
    false
  end
  
  ##
  # Sets a class accessor for the current People.
  #
  def set_current_people_id
    self.current_people_id = session[:people_id]
  end
end
