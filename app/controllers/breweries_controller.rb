class BreweriesController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /breweries
  # GET /breweries.xml
  def index
    @content_title = 'The Breweries'
    @secondary_title = 'Browsing all breweries'
    @pages, @breweries = paginate :breweries, :include => 'page',
      :order => 'breweries.title ASC', :per_page => per_page
    if @breweries.empty?
      flash.now[:notice] = 'There are no breweries yet.'
    end
    @tags = Page.tags(:limit => 25, :order => "name DESC",
      :owner_type => 'Beer')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @breweries.to_xml }
    end
  end
  
  # GET /breweries/1
  # GET /breweries/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @brewery.to_xml }
    end
  end
  
  # GET /breweries/new
  def new
    @brewery = Brewery.new
    @brewery.title = params[:new_title] if params[:new_title]
    @page = Page.new
  end
  
  # GET /breweries/1;edit
  def edit
  end
  
  # POST /breweries
  # POST /breweries.xml
  def create
    @brewery = Brewery.new(params[:brewery])
    @page = Page.new(params[:page])
    @brewery.page = @page
    allow_page_discussions
    respond_to do |format|
      if @brewery.save
        flash[:notice] = 'Brewery was successfully created.'
        format.html { redirect_to brewery_url(@brewery.page.title_for_url) }
        format.xml  { head :created,
          :location => brewery_url(@brewery.page.title_for_url) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brewery.errors.to_xml }
      end
    end
  end
  
  # PUT /breweries/1
  # PUT /breweries/1.xml
  def update
    @page.attributes = params[:page]
    @brewery.attributes = params[:brewery]
    respond_to do |format|
      if @brewery.save
        flash[:notice] = 'Brewery was successfully updated.'
        format.html { redirect_to brewery_url(@brewery.page.title_for_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brewery.errors.to_xml }
      end
    end
  end
  
  # DELETE /breweries/1
  # DELETE /breweries/1.xml
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url }
      format.xml  { head :ok }
    end
  end
end
