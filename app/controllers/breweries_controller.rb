class BreweriesController < ApplicationController
  append_before_filter :get_brewery_and_page, :only => [ :show, :edit, :update,
    :destroy ]
  
  # GET /breweries
  # GET /breweries.xml
  def index
    @pages, @breweries = paginate :breweries, :include => 'page',
      :order => 'breweries.title ASC', :per_page => 50
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
    respond_to do |format|
      @page.attributes = params[:page]
      @brewery.attributes = params[:brewery]
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
  
  protected
  
  def get_brewery_and_page
    @brewery = Brewery.find_by_title(Page.title_from_url(params[:id]),
      :include => [ 'page' ])
    raise ActiveRecord::RecordNotFound.new if @brewery.nil?
    @page = @brewery.page
  end
end
