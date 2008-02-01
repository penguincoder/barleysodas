class GalleriesController < ApplicationController
  append_before_filter :fetch_image, :only => [ :show, :destroy,
    :download_original ]
  
  # GET /images
  # GET /images.xml
  def index
    @content_title = 'Image Gallery'
    cond_ary = []
    cond_var = {
      :people_id => params[:id]
    }
    @secondary_title = "Everybody's Images"
    if params[:id]
      cond_ary << 'images.people_id = :people_id'
      @people = People.find(params[:id])
      @secondary_title = "Images from #{@people.title}"
    end
    cond_ary << '1 = 1' if cond_ary.empty?
    @pages, @images = paginate :images, :per_page => per_page,
      :order => 'images.created_at DESC', :include => [ 'people' ],
      :conditions => [ cond_ary.join(' AND '), cond_var ]
    flash.now[:notice] = 'There are no images yet.' if @images.empty?
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @images.to_xml }
    end
  end
  
  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @image.to_xml }
    end
  end
  
  # GET /galleries/new
  def new
    @image = Image.new
  end
  
  # POST /images
  # POST /images.xml
  def create
    @image = Image.new(params[:image])
    if @image.save
      flash[:notice] = 'Great success!'
      redirect_to gallery_url(@image)
    else
      render :action => :new
    end
  end
  
  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @image.destroy
    flash[:notice] = 'Destroyed the image.'
    redirect_to galleries_url(:id => @image.people_id)
  end
  
  ##
  # Sends a copy of the original Image to the People.
  #
  def download_original
    send_file("#{RAILS_ROOT}/public/images/" +
      @image.filename_for_version(:original),
      :disposition => 'inline', :type => @image.content_type)
  end
  
  protected
  
  def fetch_image
    @image = Image.find(params[:id])
  end
end
