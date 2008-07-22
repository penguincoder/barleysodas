class ExperiencesController < ApplicationController
  append_before_filter :fetch_experience, :only => [ :edit, :update, :destroy ]
  
  # GET /experiences
  def index
    redirect_to experience_url(:id => session[:people_title_for_url])
  end
  
  # GET /experiences/1
  # GET /experiences/1.xml
  def show
    @content_title = 'Experience Points'
    @people = People.find_by_title(Page.title_from_url(params[:id]))
    respond_to do |format|
      format.html do
        cond_ary = [ 'experiences.people_id = :people_id' ]
        cond_var = { :people_id => @people.id }
        conditions = [ cond_ary.join(' AND '), cond_var ]
        @total_count = Experience.count("people_id = #{@people.id}")
        @pages, @experiences = paginate :experiences,
          :order => [ 'beers.title ASC' ],
          :per_page => per_page, :conditions => conditions,
          :joins => "LEFT OUTER JOIN beers ON beers.id = experiences.beer_id"
        brewery_ids = @experiences.collect { |e| e.beer.brewery_id }
        @breweries = Brewery.find(brewery_ids, :order => 'title ASC')
        flash.now[:notice] = 'No experience yet.' if @experiences.empty?
      end
      format.rss do
        @experiences = @people.experiences.find :all, :limit => per_page,
          :order => 'experiences.created_at DESC'
        render :partial => 'experiences'
      end
    end
  end
  
  # GET /experiences/1;edit
  def edit
  end
  
  # POST /experiences
  def create
    @experience = Experience.new(params[:experience])
    @experience.people_id = session[:people_id]
    if @experience.save
      render :inline => "<%= remove_experience_link(@experience) -%>"
    else
      render :inline => "<%= error_messages_for(@experience) -%>",
        :status => 500
    end
  end
  
  # PUT /experiences/1
  def update
    if @experience.update_attributes(params[:experience])
      render :inline => "<%= add_experience_link -%>"
    else
      render :inline => "<%= error_messages_for(@experience) -%>",
        :status => 500
    end
  end
  
  # DELETE /experiences/1
  def destroy
    # not sure if this is necessary, but i'll include it for completeness.
    if @experience.destroy
      render :inline => "<%= add_experience_link -%>"
    else
      render :nothing => true, :status => 500
    end
  end
  
  protected
  
  def fetch_experience
    @experience = Experience.find(params[:id])
    raise ActiveRecord::RecordNotFound.new unless @experience
  end
end
