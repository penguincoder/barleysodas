class SessionsController < ApplicationController
  def new
    @content_title = 'Log In'
    @secondary_title = ''
  end
  
  def create
    @people = People.authenticate(params[:login], params[:password])
    if @people
      session[:people_title] = @people.title
      session[:people_title_for_url] = @people.to_param
      session[:people_id] = @people.id
      respond_to do |format|
        format.html {
          flash[:notice] = "Welcome, #{@people.title}"
          if session[:request_url]
            t_url = session[:request_url]
            session[:request_url] = nil
            redirect_to t_url
          else
            redirect_to pages_path
          end
        }
        format.xml { head :ok }
      end
    else
      respond_to do |format|
        format.html {
          @content_title = 'Log In'
          @secondary_title = ''
          flash.now[:error] = 'Login failed, try again.'
          render :action => 'new'
        }
        format.xml { render :xml => @beer.errors.to_xml, :status => 400 }
      end
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = 'You have logged out.'
    redirect_to pages_path
  end
  
  protected
  
  ##
  # Always allow People to log in and out of the system.
  #
  def authorized?
    true
  end
end
