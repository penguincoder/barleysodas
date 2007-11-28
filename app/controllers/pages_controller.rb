class PagesController < ApplicationController
  append_before_filter :fetch_page, :only => [ :show, :edit, :update, :destroy ]
  
  # GET /pages
  # GET /pages.xml
  def index
    @page = Page.find_by_title 'HomePage'
    @page ||= Page.create :title => 'HomePage',
      :redcloth => 'Welcome to BarleySodas!'
    @content_title = 'The Beer Wiki'
    @secondary_title = 'Browsing all pages'
    
    cond_ary = [ 'owner_id IS NULL' ]
    cond_ary << "title <> 'HomePage'"
    @pages, @wiki_pages = paginate :page, :per_page => 25,
      :order => 'title ASC', :conditions => [ cond_ary.join(' AND ') ]
    
    @tags = Page.tags(:limit => 25, :order => "name DESC")
    
    respond_to do |format|
      format.html # index.rhtml
    end
  end
  
  # GET /pages/1
  # GET /pages/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @page.to_xml }
    end
  end
  
  # GET /pages/new
  def new
    @page = Page.new
  end
  
  # GET /pages/1;edit
  def edit
  end
  
  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new params[:page]
    allow_page_discussions
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to page_url({ :id => @page.title_for_url }) }
        format.xml  { head :created,
          :location => page_url({ :id => @page.title_for_url }) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end
  
  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page.attributes = params[:page]
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to page_url({ :id => @page.title_for_url }) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end
  
  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.xml  { head :ok }
    end
  end
  
  ##
  # Redirects the user to a default location.
  #
  def default_action
    redirect_to(pages_path)
  end
  
  protected
  
  def fetch_page
    @page = Page.find_by_title(Page.title_from_url(params[:id]))
    raise ActiveRecord::RecordNotFound.new if @page.nil?
  end
end
