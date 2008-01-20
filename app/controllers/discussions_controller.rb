class DiscussionsController < ApplicationController
  append_before_filter :ensure_xhr, :only => [ :allow_discussions,
    :deny_discussions ]
  
  # GET /discussions
  # GET /discussions.xml
  def index
    @content_title = 'Discussion Topics'
    @secondary_title = 'All discussion topics'
    @pages, @wiki_pages = paginate :pages, :order => 'title ASC',
      :conditions => [ 'allow_discussions = ?', true ], :per_page => per_page,
      :include => [ 'discussions' ]
    respond_to do |format|
      format.html # index.rhtml
    end
  end
  
  # GET /discussions/1
  # GET /discussions/1.xml
  def show
    @page = Page.find(params[:id], :include => [ 'discussions' ])
    @secondary_title = @page.title
    @pages, @discussions = paginate :discussion, :order => 'created_at ASC',
      :conditions => [ 'page_id = ?', @page.id ], :per_page => per_page
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @discussions.to_xml }
    end
  end
  
  # POST /discussions
  # POST /discussions.xml
  def create
    @discussion = Discussion.new(params[:discussion])
    if @discussion.save
      render :partial => 'discussion',
        :locals => {
          :discussion => @discussion,
          :li_number => @discussion.page.discussions.size
         }
    else
      render :xml => @discussion.errors.to_xml, :status => 500
    end
  end
  
  # PUT /discussions/1
  # PUT /discussions/1.xml
  def update
    @discussion = Discussion.find(params[:id])
    if @discussion.update_attributes(params[:discussion])
      head :ok
    else
      render :xml => @discussion.errors.to_xml
    end
  end
  
  # DELETE /discussions/1
  # DELETE /discussions/1.xml
  def destroy
    @discussion = Discussion.find(params[:id])
    @discussion.destroy
    head :ok
  end
  
  ##
  # Forces an allow of Discussion models on a Page.
  #
  def allow_discussions
    @page = Page.find(params[:id])
    status = 500
    status = 200 if @page.update_attribute(:allow_discussions, true)
    render :nothing => true, :status => status
  end
end
