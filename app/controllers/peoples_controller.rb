class PeoplesController < ApplicationController
  append_before_filter :fetch_model,
    :only => [ :show, :edit, :update, :destroy ]
  
  # GET /peoples
  # GET /peoples.xml
  def index
    @secondary_title = 'Browsing all Peoples'
    @pages, @peoples = paginate :people, :per_page => 25, :order => 'title ASC',
      :singular_name => 'people'
    @tags = Page.tags(:limit => 25, :order => "name DESC",
      :owner_type => 'People')
    respond_to do |format|
      format.html # index.rhtml
      format.xml { render :xml => @people.to_xml }
    end
  end
  
  # GET /peoples/1
  # GET /peoples/1.xml
  def show
    @secondary_title = 'Detailed Information'
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @people.to_xml }
    end
  end
  
  # GET /peoples/new
  def new
    @secondary_title = 'Sign up for BarleySodas!'
    @people = People.new
    @people.title = params[:new_title] if params[:new_title]
    @page = Page.new
  end
  
  # GET /peoples/1;edit
  def edit
  end
  
  # POST /peoples
  # POST /peoples.xml
  def create
    @people = People.new(params[:people])
    set_people_role
    @page = Page.new(params[:page])
    @people.page = @page
    respond_to do |format|
      if @people.save
        flash[:notice] = 'People was successfully created.'
        format.html { redirect_to people_url(@people.page.title_for_url) }
        format.xml  { head :created,
          :location => people_url(@people.page.title_for_url) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @people.errors.to_xml }
      end
    end
  end
  
  # PUT /peoples/1
  # PUT /peoples/1.xml
  def update
    @people.attributes = params[:people]
    set_people_role
    @page.attributes = params[:page]
    respond_to do |format|
      if @people.update_attributes(params[:people])
        flash[:notice] = 'People was successfully updated.'
        format.html { redirect_to people_url(@people.page.title_for_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @people.errors.to_xml }
      end
    end
  end
  
  # DELETE /peoples/1
  # DELETE /peoples/1.xml
  def destroy
    @people.destroy
    respond_to do |format|
      format.html { redirect_to peoples_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def set_people_role
    # set checks here for valid role assignment
    if params[:people] and params[:people][:role_id]
      @people.role_id = params[:people][:role_id]
    end
  end
end
