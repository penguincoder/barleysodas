class TagImagesController < ApplicationController
  # GET /tag_images
  # GET /tag_images.xml
  def index
    redirect_to images_url
  end
  
  # GET /tag_images/1
  # GET /tag_images/1.xml
  def show
    @content_title = 'Tag your friends and beers!'
    @image = Image.find(params[:id], :include => [ :tag_images ])
    @tag_images = @image.tag_images
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @tag_images.to_xml }
    end
  end
  
  # POST /tag_images
  # POST /tag_images.xml
  def create
    @tag_image = TagImage.new(params[:tag_image])
    @image = @tag_image.image
    if @tag_image.save
      @tag_images = @image.tag_images
      render :partial => 'tag_images'
    else
      render :line => "<%= error_messages_for 'tag_image' %>", :status => 500
    end
  end
  
  # DELETE /tag_images/1
  # DELETE /tag_images/1.xml
  def destroy
    @tag_image = TagImage.find params[:id], :include => [ :image ]
    @image = @tag_image.image
    @tag_image.destroy
    @image.tag_images.reload
    @tag_images = @image.tag_images
    render :partial => 'tag_images'
  end
  
  ##
  # Searches for all known models that support image tagging. Sticks all of
  # the matching results into a hash that is indexed by the type.
  #
  def taggable_search
    @results = {}
    cond_ary = [ 'title ILIKE :title' ]
    cond_var = { :title => "%#{params[:name]}%" }
    TagImage.types_for_select.flatten.each do |ctype|
      klass = Class.class_eval(ctype)
      @results[ctype] = klass.find :all, :order => 'title ASC',
        :conditions => [ cond_ary.join(' AND '), cond_var ]
    end
    render :partial => 'taggable_results'
  end
  
  ##
  # Renders an Ajax browser of all tagged Image models for any +:taggable_type+
  #
  def tagged_images
    images_per_page = 4
    @page_count, @current_page, @tagged_type, @tagged_images = nil, nil, nil, nil
    @tagged_type = params[:tagged_type]
    if TagImage.types_for_select.flatten.include?(@tagged_type)
      cond_ary = [
        'tagged_type = :tt',
        'tagged_id = :tid'
      ]
      cond_var = { :tt => @tagged_type, :tid => params[:id] }
      conditions = [ cond_ary.join(' AND '), cond_var ]
      @current_page = params[:page].to_i
      @current_page = 1 if @current_page == 0
      image_count = TagImage.count(conditions)
      @page_count = (image_count.to_f / images_per_page.to_f).round
      @page_count = 1 if @page_count == 0
      @tagged_images = TagImage.find :all, :limit => images_per_page,
        :conditions => conditions, :order => 'created_at ASC',
        :offset => ((@current_page - 1) * images_per_page),
        :include => [ 'image' ]
      render :partial => 'tag_images/tagged_images'
    else
      render :nothing => true, :status => 500
    end
  end
end
