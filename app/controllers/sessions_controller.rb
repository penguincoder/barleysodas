class SessionsController < ApplicationController
  def new
    @content_title = 'Log In'
    @secondary_title = ''
  end
  
  def create
    @people = People.find_by_title(params[:login]) rescue nil
    if @people
      session[:people_title] = @people.title
      respond_to do |format|
        format.html {
          flash[:info] = "Welcome, #{@people.title}"
          if session[:request_url]
            t_url = session[:request_url]
            session[:request_url] = nil
            redirect_to t_url
          else
            redirect_to '/'
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
    redirect_to '/'
  end
end
