class HelpController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /help
  # GET /help.xml
  def index
    @page = Page.find_by_title_and_owner_type 'HomePage', 'Help'
    @content_title = 'BarleySodas Help'
    @secondary_title = ''
    @tags = Page.tags(:limit => 25, :order => 'name DESC',
      :owner_type => 'Help')
  end
  
  # GET /help/1
  # GET /help/1.xml
  def show
    @secondary_title = ''
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @page.to_xml }
    end
  end
  
  # GET /help/new
  def new
    @page = Page.new
    @page.title = params[:new_title] if params[:new_title]
    @secondary_title = 'Creating help page'
  end
  
  # GET /help/1;edit
  def edit
    @secondary_title = 'Updating help page'
  end
  
  # POST /help
  # POST /help.xml
  def create
    @page = Page.new(params[:page])
    @page.owner_type = 'Help'
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Help was successfully created.'
        format.html {
          if @page.title == 'HomePage'
            redirect_to :controller => 'help', :action => 'index'
          else
            redirect_to help_url({ :id => @page.title_for_url })
          end
        }
        format.xml  { head :created,
          :location => help_url({ :id => @page.title_for_url }) }
      else
        format.html {
          @secondary_title = 'Creating help page'
          render :action => "new"
        }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end
  
  # PUT /help/1
  # PUT /help/1.xml
  def update
    @page.attributes = params[:page]
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Help was successfully updated.'
        format.html {
          if @page.title == 'HomePage'
            redirect_to :controller => 'help', :action => 'index'
          else
            redirect_to help_url({ :id => @page.title_for_url })
          end
        }
        format.xml  { head :ok }
      else
        format.html {
          @secondary_title = 'Updating help page'
          render :action => "edit"
        }
        format.xml  { render :xml => @page.errors.to_xml, :status => 400 }
      end
    end
  end
  
  # DELETE /help/1
  # DELETE /help/1.xml
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to :controller => 'help', :action => 'index' }
      format.xml  { head :ok }
    end
  end
end
