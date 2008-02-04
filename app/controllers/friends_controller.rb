class FriendsController < ApplicationController
  append_before_filter :fetch_people, :only => [ :show, :destroy ]
  
  # GET /friends/1
  # GET /friends/1.xml
  def show
    @content_title = "Friends of #{@people.title}"
    @friends = @people.actual_friends
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @friends.to_xml }
    end
  end
  
  # POST /friends
  # POST /friends.xml
  def create
    @friend = Friend.new(params[:friend])
    @page = @friend.destination
    respond_to do |format|
      if @friend.save
        flash[:notice] = 'Successfully added the new friend'
        format.html { redirect_to people_path(@people.page.title_for_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # DELETE /friends/1
  # DELETE /friends/1.xml
  def destroy
    @friend = Friend.find :first,
      :conditions => [ 'source_id = ? AND destination_id = ?',
      params[:d].to_i, @people.id ]
    @friend.destroy if @friend
    respond_to do |format|
      flash[:notice] = 'Removed the friend'
      format.html { redirect_to people_path(@people.page.title_for_url) }
    end
  end
  
  protected
  
  def fetch_people
    @people = People.find_by_title(Page.title_from_url(params[:id]))
    raise ActiveRecord::RecordNotFound.new if @people.nil?
    @page = @people.page
  end
end
