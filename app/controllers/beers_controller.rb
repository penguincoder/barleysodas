class BeersController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /beers
  # GET /beers.xml
  def index
    @content_title = 'The Beers'
    @secondary_title = 'Browsing all beers'
    @pages, @beers = paginate :beers, :include => 'page', :per_page => 50,
      :order => 'beers.title ASC'
    
    @tags = Page.tags(:limit => 25, :order => "name DESC",
      :owner_type => 'Beer')
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @beers.to_xml }
    end
  end
  
  # GET /beers/1
  # GET /beers/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @beer.to_xml }
    end
  end
  
  # GET /beers/new
  def new
    @secondary_title = 'Create a new beer'
    @beer = Beer.new
    @beer.title = params[:new_title] if params[:new_title]
    @page = Page.new
  end
  
  # GET /beers/1;edit
  def edit
    @secondary_title = 'Update existing beer'
    @brewery = @beer.brewery
  end
  
  # POST /beers
  # POST /beers.xml
  def create
    @beer = Beer.new(params[:beer])
    @page = Page.new(params[:page])
    @beer.page = @page
    allow_page_discussions
    brewery = Brewery.find_by_title(params[:brewery][:title]) rescue nil
    @beer.brewery = brewery
    respond_to do |format|
      if @beer.save
        flash[:notice] = 'Beer was successfully created.'
        format.html { redirect_to beer_url(@beer.page.title_for_url) }
        format.xml  { head :created,
          :location => beer_url(@beer.page.title_for_url) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @beer.errors.to_xml }
      end
    end
  end
  
  # PUT /beers/1
  # PUT /beers/1.xml
  def update
    @page.attributes = params[:page]
    @beer.attributes = params[:beer]
    brewery = Brewery.find_by_title(params[:brewery][:title]) rescue nil
    @beer.brewery = brewery
    respond_to do |format|
      if @beer.save
        flash[:notice] = 'Beer was successfully updated.'
        format.html { redirect_to beer_url(@beer.page.title_for_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @beer.errors.to_xml }
      end
    end
  end
  
  # DELETE /beers/1
  # DELETE /beers/1.xml
  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url }
      format.xml  { head :ok }
    end
  end
end
