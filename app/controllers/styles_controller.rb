class StylesController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /styles
  # GET /styles.xml
  def index
    @content_title = 'Beverage Styles'
    @secondary_title = 'Major Style Categories'
    @styles = Style.major_styles
    @tags = Page.tags(:limit => 25, :order => "name DESC",
      :owner_type => 'Style')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @styles.to_xml }
    end
  end

  # GET /styles/1
  # GET /styles/1.xml
  def show
    @children = @style.children
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @style.to_xml }
    end
  end

  # GET /styles/new
  def new
    new_stuff
  end

  # GET /styles/1;edit
  def edit
    edit_stuff
  end

  # POST /styles
  # POST /styles.xml
  def create
    new_stuff
    @style.attributes = params[:style]
    @page.attributes = params[:page]
    respond_to do |format|
      if @style.save
        flash[:notice] = 'Style was successfully created.'
        format.html { redirect_to style_url(@style.page.title_for_url) }
        format.xml  { head :created, :location => style_url(@style) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @style.errors.to_xml }
      end
    end
  end

  # PUT /styles/1
  # PUT /styles/1.xml
  def update
    edit_stuff
    @style.attributes = params[:style]
    @page.attributes = params[:page]
    @style.page = @page
    respond_to do |format|
      if @style.save
        flash[:notice] = 'Style was successfully updated.'
        format.html { redirect_to style_url(@style.page.title_for_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @style.errors.to_xml }
      end
    end
  end

  # DELETE /styles/1
  # DELETE /styles/1.xml
  def destroy
    @style.destroy
    respond_to do |format|
      format.html { redirect_to styles_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def new_stuff
    @secondary_title = 'New Style'
    @style = Style.new
    @page = Page.new
    @style.page = @page
  end
  
  def edit_stuff
    @secondary_title = 'Update Style'
  end
end
