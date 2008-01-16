class RolesController < ApplicationController
  append_before_filter :fetch_role, :only => [ :show, :edit, :update, :destroy ]
  
  # GET /roles
  # GET /roles.xml
  def index
    @secondary_title = 'Role Administration'
    @pages, @roles = paginate :roles, :order => 'name ASC',
      :per_page => per_page
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @roles.to_xml }
    end
  end
  
  # GET /roles/1
  # GET /roles/1.xml
  def show
    @secondary_title = 'Role Details'
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @role.to_xml }
    end
  end
  
  # GET /roles/new
  def new
    @role = Role.new
    @secondary_title = 'Make a new Role'
  end
  
  # GET /roles/1;edit
  def edit
    @secondary_title = 'Change Role Details'
  end
  
  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])
    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to role_url(@role.code) }
        format.xml  { head :created, :location => role_url(@role.code) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors.to_xml }
      end
    end
  end
  
  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role.attributes = params[:role]
    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to role_url(@role.code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors.to_xml }
      end
    end
  end
  
  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role.destroy
    respond_to do |format|
      flash[:notice] = 'Role was successfully destroyed.'
      format.html { redirect_to roles_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def fetch_role
    @role = Role.find_by_code(params[:id])
    raise ActiveRecord::RecordNotFound if @role.nil?
  end
end
