class BeersController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /beers
  # GET /beers.xml
  def index
    respond_to do |format|
      format.html do
        @content_title = 'The Beers'
        @secondary_title = 'Browsing all beers'
        @pages, @beers = paginate :beers, :include => 'page', :per_page => per_page,
          :order => 'beers.title ASC'
        flash.now[:notice] = 'There are no beers yet.' if @beers.empty?
        @tags = Page.tags(:limit => 25, :order => "name DESC",
          :owner_type => 'Beer')
      end
      format.rss do
        @beers = Beer.find :all, :order => 'beers.created_at DESC',
          :limit => per_page
        render :partial => 'beers'
      end
    end
  end
  
  # GET /beers/1
  # GET /beers/1.xml
  def show
    person = People.find(session[:people_id], :include => [ 'experiences' ])
    @experience = person.experiences.detect { |e| e.beer_id == @beer.id }
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @beer.to_xml }
    end
  end
  
  # GET /beers/new
  def new
    new_stuff
  end
  
  # GET /beers/1;edit
  def edit
    edit_stuff
  end
  
  # POST /beers
  # POST /beers.xml
  def create
    new_stuff
    allow_page_discussions
    @page.attributes = params[:page]
    @beer.attributes = params[:beer]
    @beer.page = @page
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
    edit_stuff
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
  
  protected
  
  def new_stuff
    @secondary_title = 'Create a new beer'
    @beer = Beer.new
    @beer.title = params[:new_title] if params[:new_title]
    @page = Page.new
    @beer.page = @page
  end
  
  def edit_stuff
    @secondary_title = 'Update existing beer'
    @brewery = @beer.brewery
  end
end
