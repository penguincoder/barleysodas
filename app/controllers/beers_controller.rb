class BeersController < ApplicationController
  append_before_filter :get_beer_and_page, :only => [ :show, :edit, :update,
    :destroy ]
  
  # GET /beers
  # GET /beers.xml
  def index
    @pages, @beers = paginate :beers, :include => 'page', :per_page => 50,
      :order => 'beers.title ASC'
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
    @beer = Beer.new
    @page = Page.new
  end
  
  # GET /beers/1;edit
  def edit
  end
  
  # POST /beers
  # POST /beers.xml
  def create
    @beer = Beer.new(params[:beer])
    @page = Page.new(params[:page])
    @beer.page = @page
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
    respond_to do |format|
      @page.attributes = params[:page]
      @beer.attributes = params[:beer]
      if @beer.save
        flash[:notice] = 'Beer was successfully updated.'
        format.html { redirect_to beer_url(@beer) }
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
  
  protected
  
  def get_beer_and_page
    @beer = Beer.find_by_title(Page.title_from_url(params[:id]),
      :include => [ 'page' ])
    raise ActiveRecord::RecordNotFound.new if @beer.nil?
    @page = @beer.page
  end
end
